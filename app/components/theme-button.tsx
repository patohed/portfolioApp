'use client'

import { ModeToggle } from './toggle-theme'

export default function ThemeButton() {
  return (
    <div className="fixed top-4 right-4 z-50">
      <div className="p-2 rounded-full border dark:border-white/20 border-slate-800/20 dark:bg-slate-800/80 bg-white/80 backdrop-blur-sm shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105 dark:hover:border-primary/50 hover:border-primary">
        <ModeToggle />
      </div>
    </div>
  )
}