import { drizzle } from 'drizzle-orm/mysql2';
import mysql from 'mysql2/promise';
import * as schema from './schema';
import { eq, asc, like } from 'drizzle-orm';
import { createId } from '@paralleldrive/cuid2';

const pool = mysql.createPool(process.env.DATABASE_URL!);
export const db = drizzle(pool, { schema, mode: 'default' });

export class NodeRepository {
  async getAllFolders() {
    return db.query.nodes.findMany({
      where: eq(schema.nodes.type, 'folder'),
      orderBy: [asc(schema.nodes.name)],
    });
  }

  async getChildrenOf(folderId: string) {
    return db.query.nodes.findMany({
      where: eq(schema.nodes.parentId, folderId),
      orderBy: [asc(schema.nodes.type), asc(schema.nodes.name)],
    });
  }
  async searchByName(query: string) {

        return db.query.nodes.findMany({
            where: like(schema.nodes.name, `%${query}%`), 
            orderBy: [asc(schema.nodes.name)],
            limit: 50,
        });
    }
    async createFolder(name: string, parentId: string | null): Promise<any> {
        const newFolderData = {
            id: createId(),
            name,
            parentId: parentId === '' ? null : parentId,
            type: 'folder' as const,
            };

            await db.insert(schema.nodes).values(newFolderData);
            
            return newFolderData;
        }

}