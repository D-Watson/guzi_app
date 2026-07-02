import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login as loginApi, register as registerApi, logout as logoutApi } from '../api/auth'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || '')
  const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))

  const isLoggedIn = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.role === 'ADMIN')
  const isMerchant = computed(() => user.value?.role === 'MERCHANT')

  async function login(credentials) {
    const res = await loginApi(credentials)
    const { token: t, user: u } = res.data
    token.value = t
    user.value = u
    localStorage.setItem('token', t)
    localStorage.setItem('user', JSON.stringify(u))
    return u
  }

  async function register(data) {
    const res = await registerApi(data)
    const { token: t, user: u } = res.data
    token.value = t
    user.value = u
    localStorage.setItem('token', t)
    localStorage.setItem('user', JSON.stringify(u))
    return u
  }

  async function logout() {
    try {
      await logoutApi()
    } catch {
      // ignore
    }
    token.value = ''
    user.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  }

  return { token, user, isLoggedIn, isAdmin, isMerchant, login, register, logout }
})