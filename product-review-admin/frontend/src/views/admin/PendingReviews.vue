<template>
  <div class="page-container">
    <div class="search-bar">
      <el-input v-model="query.keyword" placeholder="搜索商品名称" clearable style="width: 200px" @clear="search" @keyup.enter="search" />
      <el-button type="primary" @click="search">搜索</el-button>
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
          <el-tag :type="statusType(row.status)" size="small" class="status-tag">
            {{ statusText(row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="提交时间" width="180">
        <template #default="{ row }">{{ row.createTime }}</template>
      </el-table-column>
      <el-table-column label="操作" width="220" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link size="small" @click="showDetail(row)">详情</el-button>
          <el-button v-if="row.status === 'PENDING'" type="success" link size="small" @click="handleApprove(row)">通过</el-button>
          <el-button v-if="row.status === 'PENDING'" type="danger" link size="small" @click="showReject(row)">驳回</el-button>
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

    <!-- Reject Dialog -->
    <el-dialog v-model="rejectDialog" title="驳回原因" width="400px">
      <el-input v-model="rejectReason" type="textarea" :rows="4" placeholder="请输入驳回原因" />
      <template #footer>
        <el-button @click="rejectDialog = false">取消</el-button>
        <el-button type="danger" :loading="rejecting" @click="confirmReject">确认驳回</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getPendingReviews, approveProduct, rejectProduct } from '../../api/review'

const router = useRouter()
const loading = ref(false)
const list = ref([])
const total = ref(0)
const query = reactive({ page: 1, size: 10, keyword: '' })
const rejectDialog = ref(false)
const rejectReason = ref('')
const rejectTarget = ref(null)
const rejecting = ref(false)

function statusType(s) {
  return { DRAFT: 'info', PENDING: 'warning', APPROVED: 'success', REJECTED: 'danger' }[s] || 'info'
}

function statusText(s) {
  return { DRAFT: '草稿', PENDING: '待审核', APPROVED: '已通过', REJECTED: '已驳回' }[s] || s
}

async function loadData() {
  loading.value = true
  try {
    const res = await getPendingReviews(query)
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
  router.push(`/admin/products/${row.id}`)
}

async function handleApprove(row) {
  try {
    await ElMessageBox.confirm('确认通过该商品审核？', '提示')
    await approveProduct(row.id)
    ElMessage.success('审核通过')
    loadData()
  } catch { /* cancel */ }
}

function showReject(row) {
  rejectTarget.value = row
  rejectReason.value = ''
  rejectDialog.value = true
}

async function confirmReject() {
  if (!rejectReason.value) {
    ElMessage.warning('请输入驳回原因')
    return
  }
  rejecting.value = true
  try {
    await rejectProduct(rejectTarget.value.id, { reason: rejectReason.value })
    ElMessage.success('已驳回')
    rejectDialog.value = false
    loadData()
  } finally {
    rejecting.value = false
  }
}

onMounted(loadData)
</script>