import { ref, computed } from 'vue'

export function useTheme() {
  const isDark = ref(false)
  
  const colors = computed(() => ({
    primary: '#8B5CF6',
    primaryDark: '#7C3AED',
    secondary: '#06B6D4',
    accent: '#10B981',
    warning: '#F59E0B',
    error: '#EF4444',
    background: isDark.value ? '#0F172A' : '#FFFFFF',
    surface: isDark.value ? '#1E293B' : '#F8FAFC',
    text: isDark.value ? '#F1F5F9' : '#1E293B',
    textSecondary: isDark.value ? '#94A3B8' : '#64748B',
    border: isDark.value ? '#334155' : '#E2E8F0'
  }))

  const gradients = computed(() => ({
    primary: 'linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%)',
    secondary: 'linear-gradient(135deg, #06B6D4 0%, #0891B2 100%)',
    accent: 'linear-gradient(135deg, #10B981 0%, #059669 100%)',
    hero: 'linear-gradient(135deg, #8B5CF6 0%, #7C3AED 50%, #06B6D4 100%)',
    card: isDark.value 
      ? 'linear-gradient(135deg, #1E293B 0%, #334155 100%)'
      : 'linear-gradient(135deg, #FFFFFF 0%, #F8FAFC 100%)'
  }))

  const shadows = computed(() => ({
    sm: isDark.value 
      ? '0 1px 2px 0 rgba(0, 0, 0, 0.3)'
      : '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
    md: isDark.value 
      ? '0 4px 6px -1px rgba(0, 0, 0, 0.3), 0 2px 4px -1px rgba(0, 0, 0, 0.2)'
      : '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
    lg: isDark.value 
      ? '0 10px 15px -3px rgba(0, 0, 0, 0.3), 0 4px 6px -2px rgba(0, 0, 0, 0.2)'
      : '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
    xl: isDark.value 
      ? '0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2)'
      : '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
    glow: isDark.value 
      ? '0 0 20px rgba(139, 92, 246, 0.3)'
      : '0 0 20px rgba(139, 92, 246, 0.2)'
  }))

  const toggleTheme = () => {
    isDark.value = !isDark.value
  }

  return {
    isDark,
    colors,
    gradients,
    shadows,
    toggleTheme
  }
}

