import { Router } from 'express';
import {
  getTasks,
  createTask,
  updateTask,
  rescheduleTask,
  deleteTask
} from '../controllers/taskController';
import { authenticateToken } from '../middleware/auth';

const router = Router();

router.use(authenticateToken);

router.get('/', getTasks);
router.post('/', createTask);
router.patch('/:id', updateTask);
router.post('/:id/reschedule', rescheduleTask);
router.delete('/:id', deleteTask);

export default router;
