<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索商品名称" clearable style="width: 200px" @clear="search" @keyup.enter="search" />
      <el-select v-model="query.status" placeholder="状态" clearable style="width: 130px" @change="search">
        <el-option label="草稿" value="DRAFT" />
        <el-option label="待审核" value="PENDING" />
        <el-option label="已通过" value="APPROVED" />
        <el-option label="已驳回" value="REJECTED" />
      </el-select>
      <el-button type="primary" @click="search">搜索</el-button>
      <router-link to="/merchant/products/create">
        <el-button type="success">新增商品</el-button>
      </router-link>
    </div>

    <el-table :data="list" v-loading="loading" stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="70" />
      <el-table-column prop="name" label="商品名称" min-width="180" show-overflow-tooltip />
      <el-table-column label="价格" width="120">
        <template #default="{ row }">¥{{ row.price }}</template>
      </el-table-column>
      <el-table-column prop="stock" label="库存" width="80" />
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="statusType(row.status)" size="small">{{ statusText(row.status) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="审核意见" min-width="180" show-overflow-tooltip>
        <template #default="{ row }">{{ row.rejectReason || '-' }}</template>
      </el-table-column>
      <el-table-column label="创建时间" width="180">
        <template #default="{ row }">{{ row.createTime }}</template>
      </el-table-column>
      <el-table-column label="操作" width="240" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link size="small" @click="showDetail(row)">详情</el-button>
          <el-button v-if="row.status === 'DRAFT' || row.status === 'REJECTED'" type="warning" link size="small" @click="editProduct(row)">编辑</el-button>
          <el-button v-if="row.status === 'DRAFT' || row.status === 'REJECTED'" type="success" link size="small" @click="handleSubmit(row)">提交审核</el-button>
          <el-button v-if="row.status === 'DRAFT'" type="danger" link size="small" @click="handleDelete(row)">删除</el-button>
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
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getMerchantProducts, submitProduct, deleteProduct } from '../../api/product'

const router = useRouter()
const loading = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ page: 1, size: 10, keyword: '', status: '' })

function statusType(s) {
  return { DRAFT: 'info', PENDING: 'warning', APPROVED: 'success', REJECTED: 'danger' }[s] || 'info'
}

function statusText(s) {
  return { DRAFT: '草稿', PENDING: '待审核', APPROVED: '已通过', REJECTED: '已驳回' }[s] || s
}

async function loadData() {
  loading.value = true
  try {
    const res = await getMerchantProducts(query)
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

function showDetail(row) {
  router.push(`/merchant/products/${row.id}`)
}

function editProduct(row) {
  router.push(`/merchant/products/${row.id}/edit`)
}

async function handleSubmit(row) {
  try {
    await ElMessageBox.confirm('确认提交该商品审核？', '提示')
    await submitProduct(row.id)
    ElMessage.success('已提交审核')
    loadData()
  } catch { /* cancel */ }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm(`确认删除商品"${row.name}"？`, '警告', { type: 'warning' })
    await deleteProduct(row.id)
    ElMessage.success('删除成功')
    loadData()
  } catch { /* cancel */ }
}

onMounted(loadData)
</script>