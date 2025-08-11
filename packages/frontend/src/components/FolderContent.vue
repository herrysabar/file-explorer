<script setup lang="ts">
defineProps<{ nodes: any[] }>();
</script>

<template>
  <div class="content-view">
    <div v-if="!nodes.length" class="empty-message">Select a folder to see its contents.</div>
    <ul v-else class="content-list">
      <li v-for="node in nodes" :key="node.id" class="content-item">
        <span class="icon">{{ node.type === 'folder' ? '📁' : '📄' }}</span>
        {{ node.name }}
      </li>
    </ul>
  </div>
</template>

<style scoped>
.content-view { padding: 10px; }
.empty-message { color: #888; }
.content-list { list-style-type: none; padding: 0; margin: 0; }
.content-item { display: flex; align-items: center; padding: 5px 0; }
.icon { margin-right: 8px; }
</style>