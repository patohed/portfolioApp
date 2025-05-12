'use client'

import { dataPortfolio } from "../data"
import Image from "next/image"
import Link from "next/link"
import { useState } from "react"

type Project = {
  id: number;
  title: string;
  image: string;
  urlGithub?: string;
  urlDemo?: string;
}

export default function Portfolio() {
  const [selectedImage, setSelectedImage] = useState<string | null>(null);

  const handleImageClick = (image: string, e: React.MouseEvent) => {
    e.preventDefault();
    setSelectedImage(image);
  };

  const renderLink = (project: Project) => {
    if (project.urlGithub?.startsWith('/')) {
      return (
        <Link
          href={project.urlGithub}
          className="bg-white text-primary hover:bg-primary hover:text-white px-6 py-2.5 rounded-lg transition-all duration-300 hover:scale-105 font-medium shadow-lg focus:ring-2 focus:ring-primary focus:ring-offset-2 border border-primary dark:bg-slate-900 dark:text-white dark:hover:bg-primary/90 dark:hover:text-black"
        >
          Github
        </Link>
      );
    }
    return (
      <a
        href={project.urlGithub}
        target="_blank"
        rel="noopener noreferrer"
        className="bg-white text-primary hover:bg-primary hover:text-white px-6 py-2.5 rounded-lg transition-all duration-300 hover:scale-105 font-medium shadow-lg focus:ring-2 focus:ring-primary focus:ring-offset-2 border border-primary dark:bg-slate-900 dark:text-white dark:hover:bg-primary/90 dark:hover:text-black"
      >
        Github
      </a>
    );
  };

  return (
    <section id="portfolio">
      <div className="max-w-6xl mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-3xl font-bold mb-4">Mi <span className="text-primary">Portafolio</span></h2>
          <p className="text-muted-foreground">Una muestra de mis proyectos más destacados</p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {dataPortfolio.map((project: Project) => (
            <div key={project.id} className="group bg-card rounded-xl overflow-hidden border hover:border-primary transition-colors">
              <div className="relative overflow-hidden aspect-video">
                <Image
                  src={project.image}
                  alt={project.title}
                  fill
                  className="object-cover transition-transform duration-300 group-hover:scale-110"
                />
                <div className="absolute inset-0 bg-black/80 flex items-center justify-center gap-4 opacity-0 group-hover:opacity-100 transition-opacity">
                  {project.urlGithub && renderLink(project)}
                  {project.urlDemo && (
                    <a
                      href={project.urlDemo}
                      onClick={(e) => handleImageClick(project.image, e)}
                      className="bg-white text-primary hover:bg-primary hover:text-white px-6 py-2.5 rounded-lg transition-all duration-300 hover:scale-105 font-medium shadow-lg focus:ring-2 focus:ring-primary focus:ring-offset-2 border border-primary dark:bg-slate-900 dark:text-white dark:hover:bg-primary/90 dark:hover:text-black"
                    >
                      Demo
                    </a>
                  )}
                </div>
              </div>
              <div className="p-6">
                <h3 className="text-lg font-bold">{project.title}</h3>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Pop-up para mostrar la imagen en grande */}
      {selectedImage && (
        <div 
          className="fixed inset-0 bg-black/90 flex items-center justify-center z-50 p-4"
          onClick={() => setSelectedImage(null)}
        >
          <div className="relative w-full max-w-4xl h-auto aspect-video">
            <Image
              src={selectedImage}
              alt="Preview"
              fill
              className="object-contain"
              priority
            />
            <button
              onClick={() => setSelectedImage(null)}
              className="absolute top-4 right-4 text-white hover:text-primary bg-black/50 rounded-full p-2"
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>
      )}
    </section>
  )
}