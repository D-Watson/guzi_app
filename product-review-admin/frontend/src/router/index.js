import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: { guest: true }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue'),
    meta: { guest: true }
  },

  // Admin Layout
  {
    path: '/admin',
    component: () => import('../views/admin/Layout.vue'),
    meta: { role: 'ADMIN' },
    children: [
      { path: '', redirect: '/admin/dashboard' },
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: () => import('../views/admin/Dashboard.vue'),
        meta: { title: '控制台' }
      },
      {
        path: 'reviews/pending',
        name: 'PendingReviews',
        component: () => import('../views/admin/PendingReviews.vue'),
        meta: { title: '待审核' }
      },
      {
        path: 'products',
        name: 'AllProducts',
        component: () => import('../views/admin/AllProducts.vue'),
        meta: { title: '商品管理' }
      },
      {
        path: 'products/:id',
        name: 'AdminProductDetail',
        component: () => import('../views/admin/ProductDetail.vue'),
        meta: { title: '商品详情' }
      },
      {
        path: 'users',
        name: 'MerchantUsers',
        component: () => import('../views/admin/Users.vue'),
        meta: { title: '商家管理' }
      },
      {
        path: 'categories',
        name: 'AdminCategories',
        component: () => import('../views/admin/Categories.vue'),
        meta: { title: '分类管理' }
      }
    ]
  },

  // Merchant Layout
  {
    path: '/merchant',
    component: () => import('../views/merchant/Layout.vue'),
    meta: { role: 'MERCHANT' },
    children: [
      { path: '', redirect: '/merchant/products' },
      {
        path: 'products',
        name: 'MerchantProducts',
        component: () => import('../views/merchant/ProductList.vue'),
        meta: { title: '我的商品' }
      },
      {
        path: 'products/create',
        name: 'CreateProduct',
        component: () => import('../views/merchant/ProductForm.vue'),
        meta: { title: '新增商品' }
      },
      {
        path: 'products/:id/edit',
        name: 'EditProduct',
        component: () => import('../views/merchant/ProductForm.vue'),
        meta: { title: '编辑商品' }
      },
      {
        path: 'products/:id',
        name: 'MerchantProductDetail',
        component: () => import('../views/merchant/ProductDetail.vue'),
        meta: { title: '商品详情' }
      }
    ]
  },

  { path: '/:pathMatch(.*)*', redirect: '/login' }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const auth = useAuthStore()

  if (to.meta.guest && auth.isLoggedIn) {
    return next(auth.isAdmin ? '/admin/dashboard' : '/merchant/products')
  }

  if (!to.meta.guest && !auth.isLoggedIn) {
    return next('/login')
  }

  if (to.meta.role && auth.user?.role !== to.meta.role) {
    return next(auth.isAdmin ? '/admin/dashboard' : '/merchant/products')
  }

  document.title = to.meta.title ? `${to.meta.title} - 商品审核管理系统` : '商品审核管理系统'
  next()
})

export default router