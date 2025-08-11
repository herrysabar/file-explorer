import { Elysia, t } from 'elysia';
import { cors } from '@elysiajs/cors';
import { NodeService } from './services/nodeService';
import { NodeRepository } from './db/repository';

const nodeRepository = new NodeRepository();
const nodeService = new NodeService(nodeRepository);

const app = new Elysia()
  .use(cors())
  .group('/api/v1', (app) =>
    app
      .get('/folders', () => nodeService.getFolderTree(), {
        detail: { summary: 'Get the entire folder structure as a tree' },
      })
      .get('/folders/:id/children', ({ params: { id } }) => nodeService.getFolderContents(id), {
          params: t.Object({ id: t.String() }), 
          detail: { summary: 'Get direct children of a folder' },
        }
      )
      .get('/search', ({ query }) => nodeService.searchNodes(query.q as string), {
        query: t.Object({
          q: t.String(),
        }),
        detail: { summary: 'Search for files and folders' },
      })
      .post('/folders', ({ body }) => nodeService.createNewFolder(body.name, body.parentId), {
          body: t.Object({
            name: t.String({ minLength: 1 }),
            parentId: t.Nullable(t.String()), 
          }),
          detail: { summary: 'Create a new folder' },
        })
  )
  .listen(3000);

console.log(`🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`);