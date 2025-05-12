import type { Metadata } from "next";
import { Urbanist } from "next/font/google";
import { Geist_Mono } from "next/font/google";
import "./globals.css";
import { ThemeProvider } from "./components/theme-provider";
import ThemeButton from "./components/theme-button";
import { SectionProvider } from "./context/section-context";

const urbanist = Urbanist({ subsets: ["latin"] });

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Patricio Millan | PmDevOps",
  description: "Landing page By PmDev",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body
        className={`${urbanist.className} ${geistMono.variable} antialiased`}
      >
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <SectionProvider>
            <ThemeButton />
            {children}
          </SectionProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
