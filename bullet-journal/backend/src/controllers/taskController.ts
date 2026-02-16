import { Response } from 'express';
import { AuthRequest } from '../middleware/auth';
import pool from '../config/database';

export const getTasks = async (req: AuthRequest, res: Response) => {
  try {
    const { startDate, endDate, projectId, state } = req.query;
    let query = `
      SELECT t.*,
        u1.name as creator_name,
        u2.name as assignee_name,
        p.name as project_name
      FROM tasks t
      LEFT JOIN users u1 ON t.created_by = u1.id
      LEFT JOIN users u2 ON t.assigned_to = u2.id
      LEFT JOIN projects p ON t.project_id = p.id
      WHERE (t.created_by = $1 OR t.assigned_to = $1)
    `;
    const params: any[] = [req.user?.id];
    let paramIndex = 2;

    if (startDate) {
      query += ` AND t.scheduled_date >= $${paramIndex}`;
      params.push(startDate);
      paramIndex++;
    }

    if (endDate) {
      query += ` AND t.scheduled_date <= $${paramIndex}`;
      params.push(endDate);
      paramIndex++;
    }

    if (projectId) {
      query += ` AND t.project_id = $${paramIndex}`;
      params.push(projectId);
      paramIndex++;
    }

    if (state) {
      query += ` AND t.state = $${paramIndex}`;
      params.push(state);
      paramIndex++;
    }

    query += ' ORDER BY t.scheduled_date ASC, t.created_at ASC';

    const result = await pool.query(query, params);
    res.json({ tasks: result.rows });
  } catch (error) {
    console.error('Get tasks error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const createTask = async (req: AuthRequest, res: Response) => {
  try {
    const { title, description, scheduledDate, projectId, assignedTo } = req.body;

    if (!title || !scheduledDate) {
      return res.status(400).json({ error: 'Title and scheduled date are required' });
    }

    const result = await pool.query(
      `INSERT INTO tasks (title, description, scheduled_date, created_by, project_id, assigned_to)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [title, description, scheduledDate, req.user?.id, projectId || null, assignedTo || null]
    );

    res.status(201).json({ task: result.rows[0] });
  } catch (error) {
    console.error('Create task error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const updateTask = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { title, description, scheduledDate, state, projectId, assignedTo, acknowledged } = req.body;

    const result = await pool.query(
      `UPDATE tasks
       SET title = COALESCE($1, title),
           description = COALESCE($2, description),
           scheduled_date = COALESCE($3, scheduled_date),
           state = COALESCE($4, state),
           project_id = $5,
           assigned_to = $6,
           acknowledged = COALESCE($7, acknowledged),
           completed_at = CASE WHEN $4 = 'done' THEN CURRENT_TIMESTAMP ELSE completed_at END
       WHERE id = $8
       RETURNING *`,
      [title, description, scheduledDate, state, projectId, assignedTo, acknowledged, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Task not found' });
    }

    res.json({ task: result.rows[0] });
  } catch (error) {
    console.error('Update task error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const rescheduleTask = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { newDate } = req.body;

    if (!newDate) {
      return res.status(400).json({ error: 'New date is required' });
    }

    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      const originalTask = await client.query('SELECT * FROM tasks WHERE id = $1', [id]);
      if (originalTask.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ error: 'Task not found' });
      }

      const task = originalTask.rows[0];
      const newMigrationCount = task.migration_count + 1;

      if (newMigrationCount >= 3) {
        await client.query('ROLLBACK');
        return res.status(400).json({
          error: 'Migration limit reached',
          message: 'This task has been rescheduled 3 times. Please confirm if it is still needed.',
          migrationCount: newMigrationCount
        });
      }

      await client.query(
        `UPDATE tasks SET state = 'rescheduled' WHERE id = $1`,
        [id]
      );

      const newTaskResult = await client.query(
        `INSERT INTO tasks (
          title, description, scheduled_date, state, created_by,
          assigned_to, project_id, migration_count, rescheduled_from
        ) VALUES ($1, $2, $3, 'not_done', $4, $5, $6, $7, $8)
        RETURNING *`,
        [
          task.title,
          task.description,
          newDate,
          task.created_by,
          task.assigned_to,
          task.project_id,
          newMigrationCount,
          id
        ]
      );

      await client.query(
        `UPDATE tasks SET rescheduled_to = $1 WHERE id = $2`,
        [newTaskResult.rows[0].id, id]
      );

      await client.query('COMMIT');

      res.json({
        originalTask: { ...task, state: 'rescheduled', rescheduled_to: newTaskResult.rows[0].id },
        newTask: newTaskResult.rows[0],
        migrationCount: newMigrationCount
      });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Reschedule task error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const deleteTask = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;

    const result = await pool.query('DELETE FROM tasks WHERE id = $1 RETURNING id', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Task not found' });
    }

    res.json({ message: 'Task deleted successfully' });
  } catch (error) {
    console.error('Delete task error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
