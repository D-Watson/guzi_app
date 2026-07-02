<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索用户名/公司" clearable style="width: 200px" @clear="search" @keyup.enter="search" />
      <el-select v-model="query.status" placeholder="状态" clearable style="width: 120px" @change="search">
        <el-option label="启用" value="ENABLED" />
        <el-option label="禁用" value="DISABLED" />
      </el-select>
      <el-button type="primary" @click="search">搜索</el-button>
    </div>

    <el-table :data="list" v-loading="loading" stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="70" />
      <el-table-column prop="username" label="用户名" width="120" />
      <el-table-column prop="companyName" label="公司名称" min-width="180" show-overflow-tooltip />
      <el-table-column prop="contactPerson" label="联系人" width="120" />
      <el-table-column prop="phone" label="手机号" width="130" />
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 'ENABLED' ? 'success' : 'danger'" size="small">
            {{ row.status === 'ENABLED' ? '启用' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="注册时间" width="180">
        <template #default="{ row }">{{ row.createTime }}</template>
      </el-table-column>
      <el-table-column label="操作" width="120" fixed="right">
        <template #default="{ row }">
          <el-button
            :type="row.status === 'ENABLED' ? 'warning' : 'success'"
            link
            size="small"
            @click="toggleStatus(row)"
          >
            {{ row.status === 'ENABLED' ? '禁用' : '启用' }}
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <div style="margin-top: 20px; display: flex; justify-content: flex-end;">
      <el-pagination
        v-model:page="query.page"
        v-model:page-size="query.size"
        :total="total"
        layout="total, prev, pager, next"
        @change="loadData"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getUserList, updateUserStatus } from '../../api/user'

const loading = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ page: 1, size: 10, keyword: '', status: '' })

async function loadData() {
  loading.value = true
  try {
    const res = await getUserList(query)
    list.value = res.data.records
    total.value = res.data.total
  } finally {
    loading.value = false
  }
}

function search() {
  query.page = 1
  loadData()
}

async function toggleStatus(row) {
  const newStatus = row.status === 'ENABLED' ? 'DISABLED' : 'ENABLED'
  const label = newStatus === 'ENABLED' ? '启用' : '禁用'
  try {
    await ElMessageBox.confirm(`确认${label}该商家？`, '提示')
    await updateUserStatus(row.id, newStatus)
    ElMessage.success(`${label}成功`)
    loadData()
  } catch { /* cancel */ }
}

onMounted(loadData)
</script>