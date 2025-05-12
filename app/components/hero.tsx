'use client'

import { dataAboutMe } from "../data"

export default function Hero() {
  return (
    <section id="home" className="min-h-[80vh] flex items-center justify-center py-16">
      <div className="max-w-6xl mx-auto px-4">
        <div className="space-y-8 text-center">
          <div className="space-y-4">
            <h1 className="text-4xl md:text-6xl font-bold">
              PmDevOps
            </h1>
            <h2 className="text-3xl md:text-5xl font-bold bg-gradient-to-r from-fuchsia-600 via-primary to-fuchsia-400 bg-clip-text text-transparent">
              Fullstack Developer
            </h2>
          </div>
          <p className="text-lg md:text-xl text-muted-foreground max-w-2xl mx-auto">
            Desarrollador web especializado en crear experiencias digitales únicas y funcionales
          </p>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto pt-8">
            {dataAboutMe.map((item) => (
              <div
                key={item.id}
                className="group relative p-6 rounded-2xl border dark:hover:border-primary/50 hover:border-primary 
                  bg-card hover:shadow-lg transition-all duration-300"
              >
                <div className="flex flex-col items-center gap-3">
                  <div className="p-3 bg-primary/10 rounded-xl text-primary group-hover:scale-110 transition-transform">
                    {item.icon}
                  </div>
                  <h3 className="font-semibold text-xl">{item.name}</h3>
                  <p className="text-muted-foreground text-center text-sm">{item.description}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  )
}