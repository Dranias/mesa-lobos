class Rol {
  final String nombre;
  final String descripcion;
  final String objetivo;
  final String imagen; // ← nueva propiedad

  Rol({
    required this.nombre,
    required this.descripcion,
    required this.objetivo,
    required this.imagen,
  });
}

final List<Rol> roles = [
  Rol(
    nombre: 'Hombres Lobo Comunes',
    descripcion:
        'Cada noche devoran a un aldeano.\n',
    objetivo: 'Matar al resto de habitantes de la aldea.',
    imagen: 'assets/roles/lobo_comun.png',
  ),
  Rol(
    nombre: 'Lobo Feroz',
    descripcion:
        'Devora junto a los lobos y puede atacar una segunda vez si no han muerto Lobos, Niño Salvaje o Perro Lobo.',
    objetivo: 'Matar al resto de habitantes de la aldea.',
    imagen: 'assets/roles/lobo_feroz.png',
  ),
  Rol(
    nombre: 'Infecto Padre de todos los Lobos',
    descripcion:
        'Cada noche despierta y devora a un aldeano junto a los demás Hombres Lobo.\n'
        'Pero la noche que él decida, después de que los Hombres Lobo se vayan a dormir, él levantará la mano.\n'
        'Esto significa que la víctima no ha muerto, sino que ha sido infectada.\n'
        '- Sólo puede utilizar el poder una vez por partida. El narrador tocará al infectado, que jugará desde ese momento como Hombre Lobo.'
        '- Si el infectado tiene un poder especial, podrá seguir usándolo normalmente, además de ser un Hombre Lobo.',
    objetivo: 'Matar al resto de habitantes de la aldea.',
    imagen: 'assets/roles/infecto_padre.png',
  ),
  Rol(
    nombre: 'Hombre Lobo Albino',
    descripcion:
        'Cada noche devora a un aldeano junto a los demás lobos. Una noche de cada dos puede eliminar a un lobo.',
    objetivo: 'Ser el único superviviente de la aldea.',
    imagen: 'assets/roles/lobo_albino.png',
  ),
  Rol(
    nombre: 'Aldeano',
    descripcion:
        'No tiene ninguna habilidad especial.\nHay 9 Aldeanos Comunes en total.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/aldeano.png',
  ),
  Rol(
    nombre: 'Vidente',
    descripcion: 'Cada noche despierta y puede ver la carta de algún jugador.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/vidente.png',
  ),
  Rol(
    nombre: 'Cupido',
    descripcion:
        'Despierta la primera noche y designa a dos jugadores los cuales quedarán enamorados durante toda la partida.\n'
        '-Puede designarse a si mismo como uno de los enamorados.\n'
        '-Si uno de los enamorados muere, el otro muere de pena inmediatamente después.\n'
        'Un enamorado nunca puede votar en contra de su pareja (ni siquiera para despistar)\n'
        'Si uno de los enamorados es un Aldeano y el otro un Hombre Lobo o Flautista, el objetivo para ambos cambia. Ahora deberán eliminar a los demas jugadores para ganar\n',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/cupido.png',
  ),
  Rol(
    nombre: 'Bruja',
    descripcion:
        'Tiene una poción curativa y una venenosa. Solo puede usar cada una una vez.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/bruja.png',
  ),
  Rol(
    nombre: 'Cazador',
    descripcion: 'Al morir dispara a otro jugador, que también muere.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/cazador.png',
  ),
  Rol(
    nombre: 'Niña Pequeña',
    descripcion:
        'Puede espiar a los lobos entreabriendo los ojos. Si la descubren, muere en silencio.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/nina_pequena.png',
  ),
  Rol(
    nombre: 'Protector',
    descripcion:
        'Protege a un jugador cada noche. No puede repetir ni proteger a la Niña Pequeña.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/protector.png',
  ),
  Rol(
    nombre: 'Anciano',
    descripcion:
        'Necesita dos ataques de lobos para morir. Si muere por linchamiento o cazador, los aldeanos pierden poderes.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/anciano.png',
  ),
  Rol(
    nombre: 'Cabeza de Turco',
    descripcion:
        'Si hay empate en el linchamiento, él será linchado. Puede decidir quién vota en el siguiente.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/cabeza_turco.png',
  ),
  Rol(
    nombre: 'Tonto de la Aldea',
    descripcion:
        'Si la Aldea vota en su contra, enseña su carta y no le podrán linchar.\n'
        'Si eso ocurre pierde su derecho a voto durante el resto de la partida.\n'
        'Si era Alguacil, pierde el cargo para el resto de la partida.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/tonto_aldea.png',
  ),
  Rol(
    nombre: 'Dos Hermanas',
    descripcion:
        'Despiertan la primera noche y se reconocen.\n'
        'De vez en cuando pueden volver a despertar, cuando el narrador lo estime oportuno.\n'
        'Hay 2 cartas de las Dos Hermanas.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/dos_hermanas.png',
  ),
  Rol(
    nombre: 'Tres Hermanos',
    descripcion:
        'Despiertan la primera noche y se reconocen.\n'
        'De vez en cuando pueden volver a despertar, cuando el narrador lo estime oportuno.\n'
        'Hay 3 cartas de los Tres Hermanos.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/tres_hermanos.png',
  ),
  Rol(
    nombre: 'Zorro',
    descripcion:
        'Despierta durante la noche y puede elegir a un grupo de 3 jugadores vecinos.\n'
        'Si en ese grupo hay al menos 1 Hombre Lobo, el narrador le hará un gesto afirmativo.\n'
        'Si en el grupo no hay ningún Hombre Lobo, el Zorro perderá su poder para el resto de la partida.\n'
        'Despierta todas las noches, pero no está obligado a utilizar su poder.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/zorro.png',
  ),
  Rol(
    nombre: 'Domador de Osos',
    descripcion:
        'Cada mañana, después de descubrir las víctimas, si hay al menos un Hombre Lobo adyacente al Domador de Osos, el narrador emitirá un gruñido.\n'
        'Sólo se tendrá en cuenta a los vecinos que todavía estén en juego.\n'
        'Si el Domador de Osos está infectado, el narrador gruñirá todos los turnos hasta que sea eliminado.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/domador_osos.png',
  ),
  Rol(
    nombre: 'Juez Tartamudo',
    descripcion:
        'Una vez en cada partida, el Juez Tartamudo puede decidir que haya dos votaciones con linchamiento seguidas.\n'
        'El Juez Tartamudo notificará al narrador su decisión mediante un gesto especial durante el primer linchamiento.\n'
        'Al terminar, el narrador comenzará la segunda votación.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/juez_tartamudo.png',
  ),
  Rol(
    nombre: 'Caballero de la Espada Oxidada',
    descripcion:
        'Si es devorado queda eliminado de la partida, pero uno de los Hombres Lobo enfermará.\n'
        'El Hombre Lobo más cercano por su izquierda morirá la noche siguiente.\n'
        'El Hombre Lobo muere durante la noche, y se anuncia al día siguiente.',
    objetivo: 'Matar a todos los Hombres Lobo.',
    imagen: 'assets/roles/caballero_espada.png',
  ),
  Rol(
    nombre: 'Ladrón',
    descripcion:
        'Para jugar con el Ladrón hay que añadir dos cartas extra de Aldeano Común.\n'
        'Durante la primera noche puede mirar esas cartas y quedarse con una.\n'
        'Si las dos cartas son Hombres Lobo, está obligado a cambiar su carta.',
    objetivo:
        'Si se queda como Ladrón tendrá que matar a los Hombres Lobo.\n'
        'Si se queda la carta que robe, tendrá que cumplir el objetivo de ese personaje.',
    imagen: 'assets/roles/ladron.png',
  ),
  Rol(
    nombre: 'Abnegada Sirvienta',
    descripcion:
        'Antes de que se revele la carta de un jugador linchado, puede revelar su identidad y cambiar su carta por la del otro jugador.\n'
        'Asume el rol del otro hasta el final de la partida.\n'
        'Si está enamorada no puede usar su poder.\n'
        'Si el personaje adoptado tenía poderes gastados, se restauran.\n'
        'Si el jugador eliminado estaba infectado, la ex-Sirvienta no lo está.\n'
        'Si era Alguacil, Guardia o Cupido, la ex-Sirvienta no lo es.\n'
        'Si estaba encantada, deja de estarlo.\n'
        'Si estaba infectada, sigue estándolo.\n'
        'Si se convierte en Flautista, Comediante, Guardia o Gitana, no se colocan cartas nuevas.',
    objetivo:
        'Si se queda como Abnegada Sirvienta debe matar a los Hombres Lobo.\n'
        'Si cambia de personaje, cumple el objetivo del mismo.',
    imagen: 'assets/roles/sirvienta.png',
  ),
  Rol(
    nombre: 'Comediante',
    descripcion:
        'Antes de la partida el narrador elige 3 personajes con poderes especiales.\n'
        'Tras repartir, deja los 3 sobrantes boca arriba en el centro.\n'
        'Cada noche, el Comediante puede usar el poder de una de esas cartas hasta la noche siguiente.\n'
        'Después de usarla, se retira la carta.\n'
        'Ninguna de las 3 cartas puede ser un Hombre Lobo.',
    objetivo:
        'Matar a todos los Hombres Lobo, excepto cuando usa poderes de otros personajes.',
    imagen: 'assets/roles/comediante.png',
  ),
  Rol(
    nombre: 'Niño Salvaje',
    descripcion:
        'Al principio es un Aldeano.\n'
        'Durante la primera noche elige un jugador.\n'
        'Si ese jugador muere, el Niño Salvaje se transforma en Hombre Lobo.\n'
        'Mientras siga vivo, actúa como Aldeano.',
    objetivo: 'Cumplir el objetivo de su personaje.',
    imagen: 'assets/roles/nino_salvaje.png',
  ),
  Rol(
    nombre: 'Perro Lobo',
    descripcion:
        'Durante la primera noche decide si es Aldeano Común o Hombre Lobo.\n'
        'No puede cambiar la decisión.',
    objetivo: 'Cumplir el objetivo del personaje elegido.',
    imagen: 'assets/roles/perro_lobo.png',
  ),
  Rol(
    nombre: 'Ángel',
    descripcion: 'Si el Ángel está en juego, la partida empieza con una votación de los Aldeanos.\n'
        'Si consigue que sea él el linchado, o el primero en ser devorado, gana la partida.\n'
        'Si no lo consigue, se convierte en un Aldeano Común.',
    objetivo: 'Conseguir que le linchen o le devoren el primero.',
    imagen: 'assets/roles/angel.png',
  ),
  Rol(
    nombre: 'Flautista',
    descripcion: 'Se despierta cada noche y hechiza a dos jugadores.\n'
        'Cuando todo el pueblo esté hechizado gana la partida.\n'
        'Si le infectan se convierte en un Hombre Lobo Común.\n'
        'El Protector no protege de su hechizo.\n'
        'La Bruja no cura su hechizo.\n'
        'El hechizo no se transfiere entre enamorados.',
    objetivo: 'Hechizar a todos los jugadores.',
    imagen: 'assets/roles/flautista.png',
  ),
  Rol(
    nombre: 'Abominable Sectario',
    descripcion: 'Antes de empezar la partida el narrador divide la Aldea en 2 grupos (por sexo, gafas, etc.).\n'
        'El Abominable Sectario pertenecerá a uno de esos grupos.',
    objetivo: 'Matar a todos los jugadores del grupo al que no pertenece.',
    imagen: 'assets/roles/sectario.png',
  ),
];

/*Rol(
    nombre: 'El Alguacil',
    descripcion:
        'Es un cargo público que se entrega a un jugador por votación.\n Los votos del Alguacil cuentan el doble.\n'
    '- No se puede rechazar el cargo.\n'
    '-Al morir, se nombra a otro jugador como sucesor.',
    objetivo: 'Matar a todos los Hombres Lobo..',
    imagen: 'assets/roles/alguacil.png',
  ),*/