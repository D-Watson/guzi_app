<template>
  <div class="page-container">
    <el-button style="margin-bottom: 16px" @click="goBack">← 返回</el-button>
    <el-card v-loading="loading">
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span>商品详情</span>
          <el-tag :type="statusType(product.status)" size="large">{{ statusText(product.status) }}</el-tag>
        </div>
      </template>

      <el-descriptions :column="2" border>
        <el-descriptions-item label="商品名称" :span="2">{{ product.name }}</el-descriptions-item>
        <el-descriptions-item label="价格">¥{{ product.price }}</el-descriptions-item>
        <el-descriptions-item label="库存">{{ product.stock }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ statusText(product.status) }}</el-descriptions-item>
        <el-descriptions-item label="驳回原因" :span="2">
          <span style="color: #f56c6c">{{ product.rejectReason || '-' }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="审核时间">{{ product.reviewTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="上架时间">{{ product.listedAt || '-' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="2">{{ product.createTime }}</el-descriptions-item>
        <el-descriptions-item label="商品描述" :span="2">{{ product.description || '-' }}</el-descriptions-item>
      </el-descriptions>

      <div v-if="product.coverImage" style="margin-top: 20px;">
        <h4 style="margin-bottom: 8px;">封面图</h4>
        <el-image :src="product.coverImage" style="width: 200px; height: 200px; border-radius: 4px;" fit="cover" />
      </div>

      <div v-if="product.images && product.images.length" style="margin-top: 20px;">
        <h4 style="margin-bottom: 8px;">商品图片</h4>
        <div style="display: flex; gap: 8px; flex-wrap: wrap;">
          <el-image v-for="(img, i) in product.images" :key="i" :src="img" :preview-src-list="product.images" style="width: 120px; height: 120px; border-radius: 4px;" fit="cover" />
        </div>
      </div>

      <div v-if="product.status === 'DRAFT' || product.status === 'REJECTED'" style="margin-top: 20px; display: flex; gap: 12px;">
        <el-button type="primary" @click="editProduct">编辑商品</el-button>
        <el-button type="success" @click="handleSubmit">提交审核</el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getMerchantProductDetail, submitProduct } from '../../api/product'

const route = useRoute()
const router = useRouter()
const loading = ref(true)
const product = ref({})

function statusType(s) {
  return { DRAFT: 'info', PENDING: 'warning', APPROVED: 'success', REJECTED: 'danger' }[s] || 'info'
}

function statusText(s) {
  return { DRAFT: '草稿', PENDING: '待审核', APPROVED: '已通过', REJECTED: '已驳回' }[s] || s
}

function goBack() {
  router.back()
}

function editProduct() {
  router.push(`/merchant/products/${route.params.id}/edit`)
}

async function handleSubmit() {
  try {
    await ElMessageBox.confirm('确认提交审核？', '提示')
    await submitProduct(route.params.id)
    ElMessage.success('已提交审核')
    router.push('/merchant/products')
  } catch { /* cancel */ }
}

onMounted(async () => {
  try {
    const res = await getMerchantProductDetail(route.params.id)
    product.value = res.data
  } finally {
    loading.value = false
  }
})
</script>