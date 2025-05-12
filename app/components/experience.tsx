'use client'

import { dataExperience } from "../data"
import { motion } from "framer-motion"

export default function Experience() {
  return (
    <section id="about-me" className="py-16">
      <div className="max-w-6xl mx-auto px-4">
        <h2 className="text-3xl md:text-4xl font-bold text-center mb-12">
          Mi <span className="text-primary">Experiencia</span>
        </h2>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
          {dataExperience.map((category) => (
            <div key={category.id} className="space-y-6">
              <h3 className="text-2xl font-semibold mb-6">{category.title}</h3>
              <div className="space-y-6">
                {category.experience.map((skill, index) => (
                  <div key={index} className="space-y-2">
                    <div className="flex justify-between items-center">
                      <h4 className="font-medium">{skill.name}</h4>
                      <span className="text-muted-foreground text-sm">{skill.subtitle}</span>
                    </div>
                    <div className="h-2 bg-muted rounded-full overflow-hidden">
                      <motion.div 
                        initial={{ width: 0 }}
                        animate={{ width: `${skill.value}%` }}
                        transition={{ duration: 1, ease: "easeOut" }}
                        className="h-full bg-primary rounded-full"
                      />
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}