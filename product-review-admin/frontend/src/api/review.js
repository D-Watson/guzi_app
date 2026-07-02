import request from './request'

export function getPendingReviews(params) {
  return request.get('/admin/reviews/pending', { params })
}

export function getAllProducts(params) {
  return request.get('/admin/products', { params })
}

export function getProductDetail(id) {
  return request.get(`/admin/products/${id}`)
}

export function approveProduct(id) {
  return request.post(`/admin/reviews/${id}/approve`)
}

export function rejectProduct(id, data) {
  return request.post(`/admin/reviews/${id}/reject`, data)
}