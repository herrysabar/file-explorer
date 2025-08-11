import { describe, it, expect } from 'vitest';
import { mount } from '@vue/test-utils';
import FolderContent from './FolderContent.vue';

describe('FolderContent.vue', () => {
  it('renders a message when no nodes are provided', () => {
    const wrapper = mount(FolderContent, { props: { nodes: [] } });
    expect(wrapper.text()).toContain('Select a folder to see its contents.');
  });

  it('renders a list of nodes correctly', () => {
    const nodes = [
      { id: '1', name: 'My File.txt', type: 'file' },
      { id: '2', name: 'My Folder', type: 'folder' },
    ];
    const wrapper = mount(FolderContent, { props: { nodes } });

    expect(wrapper.find('.empty-message').exists()).toBe(false);
    
    const listItems = wrapper.findAll('.content-item');
    expect(listItems.length).toBe(2);

    expect(listItems[0].text()).toContain('My File.txt');
    expect(listItems[0].text()).toContain('📄'); 
    expect(listItems[1].text()).toContain('My Folder');
    expect(listItems[1].text()).toContain('📁'); 
  });
});