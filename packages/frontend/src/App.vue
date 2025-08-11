<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue';
import FolderTree from './components/FolderTree.vue';
import FolderContent from './components/FolderContent.vue';
import api from './services/api';
import type { TreeNode } from '../../backend/src/services/nodeService';

const folderTree = ref<TreeNode[]>([]);
const selectedFolderContent = ref<any[]>([]);
const selectedFolder = ref<any>(null);
const searchQuery = ref('');
const searchResults = ref<any[]>([]);
const isLoadingSearch = ref(false);
const newFolderName = ref('');
const isCreatingFolder = ref(false);
const selectedFolderName = computed(() => selectedFolder.value?.name || '...');
const showCreateFolderForm = computed(() => selectedFolder.value && searchQuery.value.trim() === '');

onMounted(async () => {
  try {
    const response = await api.getFolderTree();
    folderTree.value = response.data;
  } catch (error) {
    console.error("Failed to load initial folder tree:", error);
  }
});

const handleFolderSelect = async (folder: any) => {
  selectedFolder.value = folder;
  try {
    const response = await api.getFolderContents(folder.id);
    selectedFolderContent.value = response.data;
  } catch (error) {
    console.error("Failed to load folder contents:", error);
    selectedFolderContent.value = [];
  }
};

const handleCreateFolder = async () => {
  if (newFolderName.value.trim() === '') {
    alert('Folder name cannot be empty');
    return;
  }
  if (!selectedFolder.value) {
    alert('Please select a parent folder first.');
    return;
  }

  isCreatingFolder.value = true;
  try {
    const response = await api.createFolder(newFolderName.value, selectedFolder.value.id);
    const newFolderData = response.data;

    selectedFolderContent.value.push(newFolderData);

    const parentNodeInTree = findNodeInTree(folderTree.value, selectedFolder.value.id);
    if (parentNodeInTree) {
      if (!parentNodeInTree.children) {
        parentNodeInTree.children = [];
      }
      parentNodeInTree.children.push({ ...newFolderData, children: [] });
    }
    
    newFolderName.value = '';
  } catch (error) {
    console.error("Failed to create folder:", error);
    alert('An error occurred while creating the folder.');
  } finally {
    isCreatingFolder.value = false;
  }
};

const findNodeInTree = (nodes: TreeNode[], id: string): TreeNode | null => {
  for (const node of nodes) {
    if (node.id === id) return node;
    if (node.children && node.children.length > 0) {
      const found = findNodeInTree(node.children, id);
      if (found) return found;
    }
  }
  return null;
};

let debounceTimer: number;
watch(searchQuery, (newQuery) => {
  clearTimeout(debounceTimer);
  if (newQuery.trim() === '') {
    searchResults.value = [];
    return;
  }
  
  isLoadingSearch.value = true;
  debounceTimer = setTimeout(async () => {
    try {
      const response = await api.searchNodes(newQuery);
      searchResults.value = response.data;
    } catch (error) {
      console.error("Search failed:", error);
      searchResults.value = [];
    } finally {
      isLoadingSearch.value = false;
    }
  }, 500); 
});

</script>

<template>
  <main>
    <div class="explorer-layout">
      <div class="left-panel">
        <h3 class="panel-header">Folders</h3>
        <FolderTree :nodes="folderTree" @folder-selected="handleFolderSelect" />
      </div>

      <div class="right-panel">
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Search for files and folders..." 
          class="search-input"
        />
        
        <div v-if="searchQuery.trim() !== ''">
          <h3 class="panel-header">Search Results for: "{{ searchQuery }}"</h3>
          <div v-if="isLoadingSearch">Searching...</div>
          <FolderContent v-else :nodes="searchResults" />
        </div>

        <div v-else>
          <h3 class="panel-header">Contents of: {{ selectedFolderName }}</h3>
          
          <div class="create-folder-form" v-if="showCreateFolderForm">
            <input 
              type="text" 
              v-model="newFolderName" 
              placeholder="New folder name..."
              @keyup.enter="handleCreateFolder"
              :disabled="isCreatingFolder"
            />
            <button @click="handleCreateFolder" :disabled="isCreatingFolder">
              {{ isCreatingFolder ? 'Creating...' : '+ Create' }}
            </button>
          </div>
          
          <FolderContent :nodes="selectedFolderContent" />
        </div>
      </div>
    </div>
  </main>
</template>

<style>
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  margin: 0;
  color: #333;
}

main {
  width: 100vw;
  height: 100vh;
}

.explorer-layout {
  display: flex;
  height: 100%;
  border-top: 1px solid #ddd;
}

.left-panel {
  width: 30%;
  min-width: 250px;
  border-right: 1px solid #ddd;
  padding: 10px;
  overflow-y: auto;
  background-color: #f9f9f9;
}

.right-panel {
  width: 70%;
  padding: 10px;
  overflow-y: auto;
}

.panel-header {
  margin: 0 0 10px 0;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
  font-size: 1.1em;
  font-weight: 600;
}

/* Input Pencarian */
.search-input {
  width: 100%;
  padding: 8px 10px;
  margin-bottom: 15px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  font-size: 1em;
}

.search-input:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
}

/* Form Membuat Folder */
.create-folder-form {
  display: flex;
  margin-bottom: 15px;
  gap: 8px;
}

.create-folder-form input {
  flex-grow: 1;
  padding: 8px 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 1em;
}

.create-folder-form button {
  padding: 8px 15px;
  border: none;
  background-color: #28a745;
  color: white;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
  transition: background-color 0.2s;
}

.create-folder-form button:hover {
  background-color: #218838;
}

.create-folder-form button:disabled {
  background-color: #aaa;
  cursor: not-allowed;
}

</style>