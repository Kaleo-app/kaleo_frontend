import { Card } from './ui/card';
import { Sparkles, Target, Users, Globe } from 'lucide-react';
import { CircularLogo } from './CircularLogo';

export function AboutScreen() {
  return (
    <div className="flex flex-col gap-6 pb-6">
      {/* Header */}
      <div className="bg-gradient-to-r from-primary to-accent p-8 rounded-xl text-center">
        <div className="flex justify-center mb-4">
          <CircularLogo 
            size={64} 
            backgroundColor="white" 
            borderColor="white" 
            borderWidth={2} 
          />
        </div>
        <h1 className="text-white mb-2">KaleoAppCore</h1>
        <p className="text-white/90">Conectando talento con oportunidades</p>
      </div>

      {/* Main Description */}
      <Card className="p-6 border-border">
        <h2 className="mb-4">¿Qué es KaleoAppCore?</h2>
        <p className="text-muted-foreground leading-relaxed">
          KaleoAppCore es una plataforma que centraliza y analiza convocatorias públicas 
          internacionales para facilitar el acceso a oportunidades académicas y profesionales.
        </p>
      </Card>

      {/* Features */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="p-5 border-border">
          <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mb-3">
            <Target className="w-6 h-6 text-blue-600" />
          </div>
          <h3 className="mb-2">Nuestro propósito</h3>
          <p className="text-sm text-muted-foreground">
            Democratizar el acceso a oportunidades internacionales mediante tecnología.
          </p>
        </Card>

        <Card className="p-5 border-border">
          <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-3">
            <Globe className="w-6 h-6 text-green-600" />
          </div>
          <h3 className="mb-2">Alcance global</h3>
          <p className="text-sm text-muted-foreground">
            Convocatorias de más de 50 organizaciones en todo el mundo.
          </p>
        </Card>

        <Card className="p-5 border-border">
          <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mb-3">
            <Users className="w-6 h-6 text-purple-600" />
          </div>
          <h3 className="mb-2">Para todos</h3>
          <p className="text-sm text-muted-foreground">
            Becas, empleos, investigación y voluntariado en un solo lugar.
          </p>
        </Card>
      </div>

      {/* How it works */}
      <Card className="p-6 border-border">
        <h2 className="mb-4">¿Cómo funciona?</h2>
        <div className="space-y-4">
          <div className="flex items-start gap-3">
            <div className="w-8 h-8 bg-primary text-primary-foreground rounded-full flex items-center justify-center shrink-0">
              1
            </div>
            <div>
              <h4 className="mb-1">Recolección automatizada</h4>
              <p className="text-sm text-muted-foreground">
                Nuestros sistemas recopilan convocatorias de fuentes oficiales diariamente.
              </p>
            </div>
          </div>

          <div className="flex items-start gap-3">
            <div className="w-8 h-8 bg-primary text-primary-foreground rounded-full flex items-center justify-center shrink-0">
              2
            </div>
            <div>
              <h4 className="mb-1">Normalización de datos</h4>
              <p className="text-sm text-muted-foreground">
                Organizamos la información en un formato consistente y fácil de entender.
              </p>
            </div>
          </div>

          <div className="flex items-start gap-3">
            <div className="w-8 h-8 bg-primary text-primary-foreground rounded-full flex items-center justify-center shrink-0">
              3
            </div>
            <div>
              <h4 className="mb-1">Análisis inteligente</h4>
              <p className="text-sm text-muted-foreground">
                Categorizamos y filtramos las oportunidades para que encuentres lo que buscas.
              </p>
            </div>
          </div>

          <div className="flex items-start gap-3">
            <div className="w-8 h-8 bg-primary text-primary-foreground rounded-full flex items-center justify-center shrink-0">
              4
            </div>
            <div>
              <h4 className="mb-1">Acceso directo</h4>
              <p className="text-sm text-muted-foreground">
                Te conectamos directamente con la fuente oficial para que puedas aplicar.
              </p>
            </div>
          </div>
        </div>
      </Card>

      {/* Stats */}
      <div className="grid grid-cols-3 gap-4">
        <Card className="p-4 border-border text-center">
          <p className="text-primary mb-1">500+</p>
          <p className="text-sm text-muted-foreground">Convocatorias</p>
        </Card>
        <Card className="p-4 border-border text-center">
          <p className="text-primary mb-1">50+</p>
          <p className="text-sm text-muted-foreground">Organizaciones</p>
        </Card>
        <Card className="p-4 border-border text-center">
          <p className="text-primary mb-1">30+</p>
          <p className="text-sm text-muted-foreground">Países</p>
        </Card>
      </div>

      {/* Footer */}
      <Card className="p-6 border-border bg-muted/30 text-center">
        <p className="text-sm text-muted-foreground">
          Versión 1.0.0 - Prototipo para feedback del equipo
        </p>
      </Card>
    </div>
  );
}
