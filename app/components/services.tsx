'use client'

import { dataServices } from "../data"

export default function Services() {
  return (
    <section id="services" className="py-16">
      <div className="max-w-6xl mx-auto px-4">
        <h2 className="text-3xl md:text-4xl font-bold text-center mb-12">
          Mis <span className="text-primary">Servicios</span>
        </h2>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {dataServices.map((service) => (
            <div 
              key={service.id}
              className="group bg-card p-6 rounded-2xl border hover:border-primary/50 transition-all duration-300
                hover:shadow-lg"
            >
              <div className="space-y-4">
                <div className="p-3 bg-primary/10 rounded-xl w-fit text-primary group-hover:scale-110 transition-transform">
                  {service.icon}
                </div>
                
                <h3 className="text-xl font-semibold">{service.title}</h3>
                
                <ul className="space-y-2 pt-2">
                  {service.features.map((feature, index) => (
                    <li 
                      key={index} 
                      className="flex items-start text-muted-foreground text-sm"
                    >
                      <span className="mr-2 text-primary mt-1">•</span>
                      <span>{feature.name}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}