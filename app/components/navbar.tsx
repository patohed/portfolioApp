'use client';

import { itemsNavbar } from "../data";
import { useSection } from '../context/section-context';
import { motion } from 'framer-motion';

export default function Navbar() {
  const { activeSection, setActiveSection } = useSection();

  const handleClick = (link: string) => {
    const sectionId = link.replace('#', '');
    setActiveSection(sectionId);
  };

  return (
    <nav>
      <div className="max-w-lg mx-auto flex items-center justify-center gap-1 
          px-4 py-2 dark:bg-black/20 bg-white/20 backdrop-blur-md rounded-full border border-slate-200/20 shadow-lg">
        {itemsNavbar.map((item) => (
          <button
            key={item.id}
            onClick={() => handleClick(item.link ?? '#')}
            title={`Ir a ${item.title}`}
            className={`relative p-3 rounded-full transition-all duration-300 
              ${
                activeSection === (item.link ?? '#').replace('#', '')
                  ? 'text-primary scale-110 dark:text-white dark:bg-primary/90'
                  : 'hover:text-primary/80 dark:hover:text-white hover:bg-slate-200/50 dark:hover:bg-slate-800/50'
              }
            `}
          >
            {activeSection === (item.link ?? '#').replace('#', '') && (
              <motion.div
                layoutId="active-pill"
                className="absolute inset-0 bg-slate-200/50 dark:bg-slate-800/50 rounded-full -z-10"
                transition={{ type: "spring", duration: 0.6 }}
              />
            )}
            {item.icon}
          </button>
        ))}
      </div>
    </nav>
  );
}