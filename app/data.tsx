import { Briefcase, Code2, CodeSquare, Home, Inbox, Mail, PanelsTopLeft, Phone, UserRound, UsersRound, Wrench } from "lucide-react";

export const dataAboutMe = [
    {
        id: 1,
        name: "Experiencia",
        icon: <Briefcase />,
        description: "Fullstack Developer con +4 años de experiencia",
    },
    {
        id: 2,
        name: "Clientes",
        icon: <UsersRound />,
        description: "+60 clientes satisfechos",
    },
    {
        id: 3,
        name: "Proyectos",
        icon: <Wrench />,
        description: "+15 completados",
    },
];

export const itemsNavbar = [
    {
        id: 1,
        title: "Home",
        icon: <Home size={20} />,
        link: "#home",
    },
    {
        id: 2,
        title: "User",
        icon: <UserRound size={20} />,
        link: "#about-me",
    },
    {
        id: 3,
        title: "Work",
        icon: <Briefcase size={20} />,
        link: "#portfolio",
    },
    {
        id: 4,
        title: "Services",
        icon: <Wrench size={20} />,
        link: "#services",
    },
    {
        id: 5,
        title: "Contact",
        icon: <Mail size={20} />,
        link: "#contact",
    },
];

export const dataSlider = [
    {
        id: 1,
        url: "/slider-1.jpg",
    },
    {
        id: 2,
        url: "/slider-2.jpg",
    },
    {
        id: 3,
        url: "/slider-3.jpg",
    },
    {
        id: 4,
        url: "/slider-4.jpg",
    },
]

export const dataPortfolio = [
    {
        id: 1,
        title: "Gaming Website",
        image: "/gaming-preview.png",
        urlGithub: "#!",
        urlDemo: "https://preeminent-travesseiro-8152cb.netlify.app/",
    },
    {
        id: 2,
        title: "Portfolios",
        image: "/portfolio-screenshot.png",
        urlGithub: "#!",
        urlDemo: "#!",
    },
    {
        id: 3,
        title: "Restaurant Web",
        image: "/image-1.jpg",
        urlGithub: "https://github.com/tuusuario/sushi-website",
        urlDemo: "#!",
    },
    {
        id: 4,
        title: "Desarrollo Web Ágil",
        image: "/image-2.jpg",
        urlGithub: "#!",
        urlDemo: "#!",
    },
    {
        id: 5,
        title: "Estrategias Web",
        image: "/digitalmarketing.png",
        urlGithub: "#!",
        urlDemo: "#!",
    },
    {
        id: 6,
        title: "Navegando Ideas Creativas",
        image: "/gaming-website-new.png",
        urlGithub: "/gaming",
        urlDemo: "https://preeminent-travesseiro-8152cb.netlify.app/",
    },
    {
        id: 7,
        title: "Sitios Web Impactantes",
        image: "/image-5.jpg",
        urlGithub: "#!",
        urlDemo: "#!",
    },
    {
        id: 8,
        title: "Proyectos Web Dinámicos",
        image: "/dynamicwebs.png",
        urlGithub: "#!",
        urlDemo: "#!",
    },
];

export const dataExperience = [
    {
        id: 1,
        title: "Frontend Development 💄",
        experience: [
            {
                name: "HTML",
                subtitle: "Experimentado",
                value: 80,
            },
            {
                name: "CSS",
                subtitle: "Intermedio",
                value: 75,
            },
            {
                name: "JavaScript",
                subtitle: "Experimentado",
                value: 60,
            },
            {
                name: "Tailwind CSS",
                subtitle: "Experimentado",
                value: 70,
            },
            {
                name: "React",
                subtitle: "Experimentado",
                value: 80,
            },
            {
                name: "NextJS",
                subtitle: "Experimentado",
                value: 75,
            },
        ],
    },
    {
        id: 2,
        title: "Backend Development 🥷",
        experience: [
            {
                name: "Node JS",
                subtitle: "Experimentado",
                value: 80,
            },
            {
                name: "NestJS",
                subtitle: "Experimentado",
                value: 85,
            },
            {
                name: "PostgreSQL",
                subtitle: "Experimentado",
                value: 75,
            },
            {
                name: "Mongo DB",
                subtitle: "Intermedio",
                value: 75,
            },
            {
                name: "Python",
                subtitle: "Basic",
                value: 60,
            }
        ],
    },
];

export const dataServices = [
    {
        id: 1,
        title: "Desarrollo Frontend",
        icon: <PanelsTopLeft />,
        features: [
            {
                name: "Desarrollo de aplicaciones web con React y Next.js",
            },
            {
                name: "Interfaces responsivas y modernas con Tailwind CSS",
            },
            {
                name: "Optimización de rendimiento y SEO",
            },
            {
                name: "Integración de APIs y servicios externos",
            },
            {
                name: "Gestión de estado con React Context/Redux",
            },
            {
                name: "Animaciones y transiciones fluidas",
            },
            {
                name: "Testing y depuración frontend",
            },
        ],
    },
    {
        id: 2,
        title: "Desarrollo Backend",
        icon: <CodeSquare />,
        features: [
            {
                name: "APIs RESTful con Node.js y NestJS",
            },
            {
                name: "Arquitectura de microservicios",
            },
            {
                name: "Bases de datos SQL y NoSQL",
            },
            {
                name: "Autenticación y autorización",
            },
            {
                name: "Integración de servicios en la nube",
            },
            {
                name: "Websockets para tiempo real",
            },
            {
                name: "Testing y documentación de APIs",
            },
        ],
    },
    {
        id: 3,
        title: "Servicios DevOps",
        icon: <Wrench />,
        features: [
            {
                name: "Despliegue continuo (CI/CD)",
            },
            {
                name: "Containerización con Docker",
            },
            {
                name: "Configuración de servidores",
            },
            {
                name: "Monitoreo y logging",
            },
            {
                name: "Optimización de rendimiento",
            },
            {
                name: "Seguridad y backups",
            },
            {
                name: "Mantenimiento y escalabilidad",
            },
        ],
    },
];

export const dataContact = [
    {
        id: 1,
        title: "Teléfono",
        subtitle: process.env.NEXT_PUBLIC_CONTACT_PHONE || "+34 677 66 66 33",
        link: `tel:${process.env.NEXT_PUBLIC_CONTACT_PHONE?.replace(/\s/g, '') || "+34677666633"}`,
        icon: <Phone />,
    },
    {
        id: 2,
        title: "Github",
        subtitle: `github.com/${process.env.NEXT_PUBLIC_GITHUB_USERNAME || "tuusuario"}`,
        link: `https://github.com/${process.env.NEXT_PUBLIC_GITHUB_USERNAME || "tuusuario"}`,
        icon: <Code2 />,
    },
    {
        id: 3,
        title: "Email",
        subtitle: process.env.NEXT_PUBLIC_CONTACT_EMAIL || "email@email.com",
        link: `mailto:${process.env.NEXT_PUBLIC_CONTACT_EMAIL || "email@email.com"}`,
        icon: <Inbox />,
    },
];

export const dataTestimonials = [
    {
        id: 1,
        name: "George Snow",
        description:
            "¡Increíble plataforma! Los testimonios aquí son genuinos y me han ayudado a tomar decisiones informadas. ¡Altamente recomendado!",
        imageUrl: "/profile-1.jpeg",
    },
    {
        id: 2,
        name: "Juan Pérez",
        description:
            "Me encanta la variedad de testimonios disponibles en esta página. Es inspirador ver cómo otras personas han superado desafíos similares a los míos. ¡Gracias por esta invaluable fuente de motivación!",
        imageUrl: "/profile-2.jpeg",
    },
    {
        id: 3,
        name: "María García",
        description:
            "Excelente recurso para obtener opiniones auténticas sobre diferentes productos y servicios. Me ha ayudado mucho en mis compras en línea. ¡Bravo por este sitio!",
        imageUrl: "/profile-3.jpeg",
    },
    {
        id: 4,
        name: "Laura Snow",
        description:
            "¡Qué descubrimiento tan fantástico! Los testimonios aquí son honestos y detallados. Me siento más seguro al tomar decisiones después de leer las experiencias compartidas por otros usuarios.",
        imageUrl: "/profile-3.jpeg",
    },
    {
        id: 5,
        name: "Carlos Sánchez",
        description:
            "Una joya en la web. Los testimonios son fáciles de encontrar y están bien organizados. ¡Definitivamente mi destino número uno cuando necesito referencias confiables!",
        imageUrl: "/profile-2.jpeg",
    },
    {
        id: 6,
        name: "Antonio Martínez",
        description:
            "¡Fantástico recurso para aquellos que buscan validación antes de tomar decisiones importantes! Los testimonios aquí son veraces y realmente útiles. ¡Gracias por simplificar mi proceso de toma de decisiones!",
        imageUrl: "/profile-3.jpeg",
    },
];