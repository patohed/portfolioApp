'use client'

import { dataContact } from "../data"
import { useState } from "react"
import { Button } from "@/components/ui/button"

export default function Contact() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    message: ''
  })

  const sanitizeInput = (input: string): string => {
    // Remover caracteres especiales y patrones SQL comunes
    return input
      .replace(/[^\w\s@.-]/gi, '') // Solo permite letras, números, @, puntos y guiones
      .replace(/(\b(select|insert|update|delete|drop|union|exec|exec\s*\(|schema|--)\b)/gi, '') // Previene palabras clave SQL
      .trim()
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    
    // Sanitizar todos los inputs antes de procesar
    const sanitizedData = {
      name: sanitizeInput(formData.name),
      email: sanitizeInput(formData.email),
      message: sanitizeInput(formData.message)
    }
    
    // Validación adicional del email
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailPattern.test(sanitizedData.email)) {
      alert('Por favor ingresa un email válido')
      return
    }

    // Aquí puedes agregar la lógica para enviar el formulario con los datos sanitizados
    console.log(sanitizedData)
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  return (
    <section id="contact" className="py-12 pb-6 pt-32">
      <div className="max-w-6xl mx-auto">
        <h2 className="text-3xl md:text-4xl font-bold text-center mb-12">
          Contacto <span className="text-primary">& Conexiones</span>
        </h2>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-3xl mx-auto mb-16">
          {dataContact.map((contact) => (
            <a
              href={contact.link}
              key={contact.id}
              target="_blank"
              rel="noopener noreferrer"
              className="bg-card p-6 rounded-lg shadow-lg border hover:border-primary transition-colors flex flex-col items-center gap-4 group"
            >
              <div className="p-3 bg-primary/10 rounded-full text-primary group-hover:bg-primary group-hover:text-white transition-colors">
                {contact.icon}
              </div>
              <div className="text-center">
                <h3 className="font-semibold text-xl mb-1">{contact.title}</h3>
                <p className="text-muted-foreground">{contact.subtitle}</p>
              </div>
            </a>
          ))}
        </div>

        <div className="max-w-xl mx-auto">
          <h3 className="text-2xl font-bold text-center mb-8">
            Envíame un <span className="text-primary">Mensaje</span>
          </h3>
          
          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label htmlFor="name" className="block text-sm font-medium mb-2">
                Nombre
              </label>
              <input
                type="text"
                id="name"
                name="name"
                value={formData.name}
                onChange={handleChange}
                required
                className="w-full px-4 py-2 border rounded-lg bg-card focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="Tu nombre"
              />
            </div>
            
            <div>
              <label htmlFor="email" className="block text-sm font-medium mb-2">
                Email
              </label>
              <input
                type="email"
                id="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                required
                className="w-full px-4 py-2 border rounded-lg bg-card focus:outline-none focus:ring-2 focus:ring-primary"
                placeholder="tu@email.com"
              />
            </div>
            
            <div>
              <label htmlFor="message" className="block text-sm font-medium mb-2">
                Mensaje
              </label>
              <textarea
                id="message"
                name="message"
                value={formData.message}
                onChange={handleChange}
                required
                rows={5}
                className="w-full px-4 py-2 border rounded-lg bg-card focus:outline-none focus:ring-2 focus:ring-primary resize-none"
                placeholder="Tu mensaje aquí..."
              />
            </div>
            
            <Button
              type="submit"
              className="w-full bg-white text-primary hover:bg-primary hover:text-white border border-primary shadow-lg"
              size="lg"
            >
              Enviar Mensaje
            </Button>
          </form>
        </div>
      </div>
    </section>
  )
}