extension CardTypeTranslator on String {
  String get translated {
    const types = {
      'Effect Monster': 'Monstro de Efeito',
      'Normal Monster': 'Monstro Normal',
      'Flip Effect Monster': 'Monstro de Efeito Virar',
      'Union Effect Monster': 'Monstro de Efeito União',
      'Tuner Monster': 'Monstro Regulador',
      'Gemini Monster': 'Monstro Gêmeos',
      'Spell Card': 'Carta de Magia',
      'Trap Card': 'Carta de Armadilha',
      'Fusion Monster': 'Monstro de Fusão',
      'Synchro Monster': 'Monstro Sincro',
      'Synchro Tuner Monster': 'Monstro Sincro Regulador',
      'XYZ Monster': 'Monstro Xyz',
      'Link Monster': 'Monstro Link',
      'Ritual Monster': 'Monstro de Ritual',
      'Ritual Effect Monster': 'Monstro de Efeito de Ritual',
      'Pendulum Normal Monster': 'Monstro Normal Pêndulo',
      'Pendulum Effect Monster': 'Monstro de Efeito Pêndulo',
      'Token': 'Ficha',
      'Skill Card': 'Carta de Habilidade',
    };
    return types[this] ?? this;
  }
}