import request from './request'

export function getMerchantProducts(params) {
  return request.get('/merchant/products', { params })
}

export function getMerchantProductDetail(id) {
  return request.get(`/merchant/products/${id}`)
}

export function createProduct(data) {
  return request.post('/merchant/products', data)
}

export function updateProduct(id, data) {
  return request.put(`/merchant/products/${id}`, data)
}

export function submitProduct(id) {
  return request.post(`/merchant/products/${id}/submit`)
}

export function deleteProduct(id) {
  return request.delete(`/merchant/products/${id}`)
}

export function uploadImage(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request.post('/merchant/images/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}