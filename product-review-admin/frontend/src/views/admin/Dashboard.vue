<template>
  <div class="page-container">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card shadow="hover">
          <div style="text-align: center; padding: 20px 0;">
            <div style="color: #409eff; font-size: 36px; margin-bottom: 10px;">
              <el-icon :size="36"><Clock /></el-icon>
            </div>
            <div style="font-size: 28px; font-weight: bold; color: #303133;">{{ pendingCount }}</div>
            <div style="color: #909399; margin-top: 8px;">待审核商品</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div style="text-align: center; padding: 20px 0;">
            <div style="color: #67c23a; font-size: 36px; margin-bottom: 10px;">
              <el-icon :size="36"><CircleCheck /></el-icon>
            </div>
            <div style="font-size: 28px; font-weight: bold; color: #303133;">{{ approvedCount }}</div>
            <div style="color: #909399; margin-top: 8px;">已通过</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div style="text-align: center; padding: 20px 0;">
            <div style="color: #f56c6c; font-size: 36px; margin-bottom: 10px;">
              <el-icon :size="36"><CircleClose /></el-icon>
            </div>
            <div style="font-size: 28px; font-weight: bold; color: #303133;">{{ rejectedCount }}</div>
            <div style="color: #909399; margin-top: 8px;">已驳回</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div style="text-align: center; padding: 20px 0;">
            <div style="color: #e6a23c; font-size: 36px; margin-bottom: 10px;">
              <el-icon :size="36"><UserFilled /></el-icon>
            </div>
            <div style="font-size: 28px; font-weight: bold; color: #303133;">{{ merchantCount }}</div>
            <div style="color: #909399; margin-top: 8px;">商家总数</div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getAllProducts } from '../../api/review'
import { getUserList } from '../../api/user'

const pendingCount = ref(0)
const approvedCount = ref(0)
const rejectedCount = ref(0)
const merchantCount = ref(0)

async function loadStats() {
  const statuses = ['PENDING', 'APPROVED', 'REJECTED']
  const results = await Promise.all(
    statuses.map(s => getAllProducts({ status: s, page: 1, size: 1 }).catch(() => ({ data: { total: 0 } })))
  )
  pendingCount.value = results[0]?.data?.total || 0
  approvedCount.value = results[1]?.data?.total || 0
  rejectedCount.value = results[2]?.data?.total || 0

  const userRes = await getUserList({ page: 1, size: 1 }).catch(() => ({ data: { total: 0 } }))
  merchantCount.value = userRes?.data?.total || 0
}

onMounted(loadStats)
</script>