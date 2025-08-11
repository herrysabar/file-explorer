import { NodeRepository } from '../db/repository';
import { nodes } from '../db/schema';

type Node = typeof nodes.$inferSelect;
export type TreeNode = Node & { children: TreeNode[] };

export class NodeService {
  constructor(private readonly nodeRepository: NodeRepository) {}

  async getFolderTree(): Promise<TreeNode[]> {
    const allFolders = await this.nodeRepository.getAllFolders();
    return this.buildTree(allFolders);
  }

  async getFolderContents(folderId: string) {
    return await this.nodeRepository.getChildrenOf(folderId);
  }
  
  private buildTree(nodes: Node[], parentId: string | null = null): TreeNode[] {
    return nodes
      .filter(node => node.parentId === parentId)
      .map(node => ({
        ...node,
        children: this.buildTree(nodes, node.id),
      }));
  }
  async searchNodes(query: string) {
    if (!query || query.trim() === '') {
        return [];
    }
    return await this.nodeRepository.searchByName(query);
  }
  async createNewFolder(name: string, parentId: string | null) {
    if (!name || name.trim() === '') {
      throw new Error('Folder name cannot be empty');
    }
    return await this.nodeRepository.createFolder(name, parentId);
  }  

}