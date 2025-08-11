import axios from 'axios';

const apiClient = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
  headers: {
    'Content-Type': 'application/json',
  },
});

export default {
  getFolderTree() {
    return apiClient.get('/folders');
  },
  getFolderContents(folderId: string) {
    return apiClient.get(`/folders/${folderId}/children`);
  },
  searchNodes(query: string) {
    return apiClient.get(`/search?q=${query}`);
  },
  createFolder(name: string, parentId: string | null) {
    return apiClient.post('/folders', { name, parentId });
  },
};