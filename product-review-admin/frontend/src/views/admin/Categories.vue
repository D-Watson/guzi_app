<template>
  <div class="page-container">
    <div style="margin-bottom: 16px;">
      <el-button type="primary" @click="showAdd">新增分类</el-button>
    </div>

    <el-table :data="list" v-loading="loading" stripe row-key="id" :tree-props="{ children: 'children' }" style="width: 100%">
      <el-table-column prop="name" label="分类名称" min-width="200" />
      <el-table-column label="层级" width="80">
        <template #default="{ row }">第{{ row.level + 1 }}级</template>
      </el-table-column>
      <el-table-column prop="sortOrder" label="排序" width="80" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link size="small" @click="showEdit(row)">编辑</el-button>
          <el-button type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- Category Form Dialog -->
    <el-dialog v-model="dialog" :title="isEdit ? '编辑分类' : '新增分类'" width="450px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="名称" prop="name">
          <el-input v-model="form.name" placeholder="分类名称" />
        </el-form-item>
        <el-form-item label="父分类">
          <el-tree-select
            v-model="form.parentId"
            :data="list"
            :props="{ label: 'name', value: 'id', children: 'children' }"
            placeholder="不选则作为根分类"
            clearable
            style="width: 100%"
            check-strictly
          />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sortOrder" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialog = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCategoryTree, createCategory, updateCategory, deleteCategory } from '../../api/category'

const loading = ref(false)
const saving = ref(false)
const list = ref([])
const dialog = ref(false)
const isEdit = ref(false)
const editId = ref(null)
const formRef = ref(null)

const form = reactive({
  name: '',
  parentId: null,
  sortOrder: 0
})

const rules = {
  name: [{ required: true, message: '请输入分类名称', trigger: 'blur' }]
}

async function loadData() {
  loading.value = true
  try {
    const res = await getCategoryTree()
    list.value = res.data || []
  } finally {
    loading.value = false
  }
}

function showAdd() {
  isEdit.value = false
  editId.value = null
  form.name = ''
  form.parentId = null
  form.sortOrder = 0
  dialog.value = true
}

function showEdit(row) {
  isEdit.value = true
  editId.value = row.id
  form.name = row.name
  form.parentId = row.parentId
  form.sortOrder = row.sortOrder
  dialog.value = true
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  saving.value = true
  try {
    if (isEdit.value) {
      await updateCategory(editId.value, form)
      ElMessage.success('更新成功')
    } else {
      await createCategory(form)
      ElMessage.success('新增成功')
    }
    dialog.value = false
    loadData()
  } finally {
    saving.value = false
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm(`确认删除分类"${row.name}"？`, '提示')
    await deleteCategory(row.id)
    ElMessage.success('删除成功')
    loadData()
  } catch { /* cancel */ }
}

onMounted(loadData)
</script>