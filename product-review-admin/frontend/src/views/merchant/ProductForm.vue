<template>
  <div class="page-container">
    <el-card>
      <template #header>
        <span>{{ isEdit ? '编辑商品' : '新增商品' }}</span>
      </template>

      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px" class="product-form" style="max-width: 600px;">
        <el-form-item label="商品名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入商品名称" />
        </el-form-item>

        <el-form-item label="商品分类" prop="categoryId">
          <el-tree-select
            v-model="form.categoryId"
            :data="categories"
            :props="{ label: 'name', value: 'id', children: 'children' }"
            placeholder="请选择分类"
            clearable
            style="width: 100%"
            check-strictly
          />
        </el-form-item>

        <el-form-item label="价格" prop="price">
          <el-input-number v-model="form.price" :min="0" :precision="2" :step="0.1" style="width: 200px;" />
        </el-form-item>

        <el-form-item label="库存" prop="stock">
          <el-input-number v-model="form.stock" :min="0" style="width: 200px;" />
        </el-form-item>

        <el-form-item label="封面图">
          <el-upload
            :show-file-list="false"
            :http-request="handleUpload"
            accept="image/png,image/jpeg,image/webp"
          >
            <el-image v-if="form.coverImage" :src="form.coverImage" style="width: 120px; height: 120px; border-radius: 4px;" fit="cover" />
            <div v-else class="image-uploader">
              <el-icon class="upload-icon"><Plus /></el-icon>
            </div>
          </el-upload>
        </el-form-item>

        <el-form-item label="商品图片">
          <div class="image-uploader">
            <el-image
              v-for="(img, i) in form.images"
              :key="i"
              :src="img"
              style="width: 100px; height: 100px; border-radius: 4px; cursor: pointer;"
              fit="cover"
              @click="form.images.splice(i, 1)"
            />
            <el-upload
              v-if="form.images.length < 10"
              :show-file-list="false"
              :http-request="handleUploadImage"
              accept="image/png,image/jpeg,image/webp"
            >
              <el-icon class="upload-icon" style="font-size: 28px; color: #8c939d;"><Plus /></el-icon>
            </el-upload>
          </div>
        </el-form-item>

        <el-form-item label="商品描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="4" placeholder="请输入商品描述" />
        </el-form-item>

        <el-form-item>
          <el-button type="primary" :loading="saving" @click="handleSave">保存草稿</el-button>
          <el-button type="success" :loading="submitting" @click="handleSubmit">提交审核</el-button>
          <el-button @click="goBack">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { createProduct, updateProduct, submitProduct, uploadImage, getMerchantProductDetail } from '../../api/product'
import { getCategoryTree } from '../../api/category'

const route = useRoute()
const router = useRouter()
const formRef = ref(null)
const saving = ref(false)
const submitting = ref(false)
const categories = ref([])

const isEdit = computed(() => !!route.params.id)

const form = reactive({
  name: '',
  categoryId: null,
  price: 0,
  stock: 0,
  coverImage: '',
  images: [],
  description: ''
})

const rules = {
  name: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }]
}

async function loadCategories() {
  try {
    const res = await getCategoryTree()
    categories.value = res.data || []
  } catch { /* ignore */ }
}

async function loadProduct() {
  if (!isEdit.value) return
  try {
    const res = await getMerchantProductDetail(route.params.id)
    const p = res.data
    form.name = p.name
    form.categoryId = p.categoryId
    form.price = p.price
    form.stock = p.stock
    form.coverImage = p.coverImage || ''
    form.images = p.images || []
    form.description = p.description || ''
  } catch { /* ignore */ }
}

async function handleUpload(options) {
  try {
    const res = await uploadImage(options.file)
    form.coverImage = res.data.url
  } catch { /* ignore */ }
}

async function handleUploadImage(options) {
  try {
    const res = await uploadImage(options.file)
    form.images.push(res.data.url)
  } catch { /* ignore */ }
}

async function handleSave() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  saving.value = true
  try {
    if (isEdit.value) {
      await updateProduct(route.params.id, form)
    } else {
      await createProduct(form)
    }
    ElMessage.success('保存成功')
    router.push('/merchant/products')
  } finally {
    saving.value = false
  }
}

async function handleSubmit() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  submitting.value = true
  try {
    if (isEdit.value) {
      await updateProduct(route.params.id, form)
      await submitProduct(route.params.id)
    } else {
      const res = await createProduct(form)
      await submitProduct(res.data.id)
    }
    ElMessage.success('已提交审核')
    router.push('/merchant/products')
  } finally {
    submitting.value = false
  }
}

function goBack() {
  router.push('/merchant/products')
}

onMounted(() => {
  loadCategories()
  loadProduct()
})
</script>