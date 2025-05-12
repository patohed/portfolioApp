'use client';

import Hero from "./components/hero";
import Experience from "./components/experience";
import Services from "./components/services";
import Portfolio from "./components/portfolio";
import Contact from "./components/contact";
import Navbar from "./components/navbar";
import { useSection } from "./context/section-context";
import { AnimatePresence, motion } from "framer-motion";

export default function Home() {
  const { activeSection } = useSection();

  const sections = [
    { id: 'home', component: <Hero /> },
    { id: 'about-me', component: <Experience /> },
    { id: 'portfolio', component: <Portfolio /> },
    { id: 'services', component: <Services /> },
    { id: 'contact', component: <Contact /> },
  ];

  return (
    <div className="relative min-h-screen">
      <main className="container mx-auto px-4 pb-24">
        <AnimatePresence mode="wait">
          {sections.map(({ id, component }) => (
            activeSection === id && (
              <motion.div
                key={id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -20 }}
                transition={{ duration: 0.4, ease: "easeInOut" }}
              >
                {component}
              </motion.div>
            )
          ))}
        </AnimatePresence>
      </main>
      <div className="fixed bottom-8 left-0 right-0 z-50">
        <Navbar />
      </div>
    </div>
  );
}
