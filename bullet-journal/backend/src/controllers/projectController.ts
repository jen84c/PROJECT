import { Response } from 'express';
import { AuthRequest } from '../middleware/auth';
import pool from '../config/database';

export const getProjects = async (req: AuthRequest, res: Response) => {
  try {
    const { archived } = req.query;
    let query = `
      SELECT p.*, u.name as creator_name,
        (SELECT COUNT(*) FROM tasks WHERE project_id = p.id AND state != 'done') as active_task_count
      FROM projects p
      LEFT JOIN users u ON p.created_by = u.id
      WHERE p.created_by = $1
    `;
    const params: any[] = [req.user?.id];

    if (archived !== undefined) {
      query += ' AND p.archived = $2';
      params.push(archived === 'true');
    } else {
      query += ' AND p.archived = false';
    }

    query += ' ORDER BY p.created_at DESC';

    const result = await pool.query(query, params);
    res.json({ projects: result.rows });
  } catch (error) {
    console.error('Get projects error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const createProject = async (req: AuthRequest, res: Response) => {
  try {
    const { name, description, color, icon } = req.body;

    if (!name) {
      return res.status(400).json({ error: 'Project name is required' });
    }

    const result = await pool.query(
      `INSERT INTO projects (name, description, color, icon, created_by)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [name, description, color || '#6B7280', icon, req.user?.id]
    );

    res.status(201).json({ project: result.rows[0] });
  } catch (error) {
    console.error('Create project error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const updateProject = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { name, description, color, icon, archived } = req.body;

    const result = await pool.query(
      `UPDATE projects
       SET name = COALESCE($1, name),
           description = COALESCE($2, description),
           color = COALESCE($3, color),
           icon = COALESCE($4, icon),
           archived = COALESCE($5, archived)
       WHERE id = $6 AND created_by = $7
       RETURNING *`,
      [name, description, color, icon, archived, id, req.user?.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Project not found' });
    }

    res.json({ project: result.rows[0] });
  } catch (error) {
    console.error('Update project error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const deleteProject = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      'DELETE FROM projects WHERE id = $1 AND created_by = $2 RETURNING id',
      [id, req.user?.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Project not found' });
    }

    res.json({ message: 'Project deleted successfully' });
  } catch (error) {
    console.error('Delete project error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
