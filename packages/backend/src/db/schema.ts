import { mysqlTable, varchar, timestamp, mysqlEnum } from 'drizzle-orm/mysql-core';
import { createId } from '@paralleldrive/cuid2';

export const nodes = mysqlTable('nodes', {
  id: varchar('id', { length: 36 }).primaryKey().$defaultFn(() => createId()),
  parentId: varchar('parent_id', { length: 36 }),
  name: varchar('name', { length: 255 }).notNull(),
  type: mysqlEnum('type', ['folder', 'file']).notNull(),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').onUpdateNow(),
});