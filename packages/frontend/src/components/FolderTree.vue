<script setup lang="ts">
import { ref } from 'vue';

defineProps<{ nodes: any[] }>();
const emit = defineEmits(['folder-selected']);

const openFolders = ref(new Set<string>());

const toggleFolder = (folderId: string) => {
  openFolders.value.has(folderId)
    ? openFolders.value.delete(folderId)
    : openFolders.value.add(folderId);
};

const selectFolder = (folder: any) => {
  emit('folder-selected', folder);
};
</script>

<template>
  <ul class="folder-tree">
    <li v-for="node in nodes" :key="node.id">
      <div @click="selectFolder(node)" class="folder-item">
        <span v-if="node.children?.length" @click.stop="toggleFolder(node.id)" class="toggle">
          {{ openFolders.has(node.id) ? '▼' : '►' }}
        </span>
        <span v-else class="spacer"></span>
        <span class="icon">📁</span>
        {{ node.name }}
      </div>
      <FolderTree
        v-if="node.children?.length && openFolders.has(node.id)"
        :nodes="node.children"
        @folder-selected="selectFolder"
        class="nested"
      />
    </li>
  </ul>
</template>

<style scoped>
.folder-tree { list-style-type: none; padding-left: 20px; margin: 0; }
.folder-item { cursor: pointer; display: flex; align-items: center; padding: 4px 0; }
.folder-item:hover { background-color: #eee; }
.toggle, .spacer { width: 20px; text-align: center; }
.icon { margin-right: 8px; }
.nested { padding-left: 25px; }
</style>