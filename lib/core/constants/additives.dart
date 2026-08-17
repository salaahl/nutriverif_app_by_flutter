class AdditiveInfo {
  final String name;
  final int score;
  final String description;

  const AdditiveInfo({
    required this.name,
    required this.score,
    required this.description,
  });
}

final Map<String, AdditiveInfo> additivesDatabase = {
  // === COLORANTS (E100 - E199) ===
  'E100': const AdditiveInfo(
    name: 'Curcumine',
    score: 1,
    description: 'Colorant jaune naturel (Curcuma). Inoffensif.',
  ),
  'E101': const AdditiveInfo(
    name: 'Riboflavine',
    score: 1,
    description: 'Vitamine B2. Colorant jaune totalement sûr.',
  ),
  'E120': const AdditiveInfo(
    name: 'Acide carminique (Cochenille)',
    score: 3,
    description:
        "Colorant rouge extrait d'insectes. Risques d'allergies et d'hyperactivité.",
  ),
  'E133': const AdditiveInfo(
    name: 'Bleu brillant FCF',
    score: 3,
    description:
        "Colorant bleu de synthèse. Risques d'allergies et intolérances suspectés.",
  ),
  'E150a': const AdditiveInfo(
    name: 'Caramel ordinaire',
    score: 1,
    description: 'Caramel simple. Aucun danger détecté.',
  ),
  'E150c': const AdditiveInfo(
    name: 'Caramel au ammoniaque',
    score: 3,
    description:
        "Procédé chimique créant des résidus (4-MEI) suspectés d'être génotoxiques.",
  ),
  'E150d': const AdditiveInfo(
    name: "Caramel au sulfite d'ammoniaque",
    score: 3,
    description:
        'Très fréquent dans les sodas. Contient des résidus de fabrication suspects.',
  ),
  'E160a': const AdditiveInfo(
    name: 'Bêta-carotène',
    score: 1,
    description: 'Précurseur de la vitamine A. Origine naturelle, sûr.',
  ),
  'E160c': const AdditiveInfo(
    name: 'Extrait de paprika',
    score: 1,
    description: 'Colorant orange extrait du piment doux. Inoffensif.',
  ),
  'E162': const AdditiveInfo(
    name: 'Rouge de betterave',
    score: 1,
    description: 'Colorant naturel extrait de la betterave. Aucun risque.',
  ),
  'E170': const AdditiveInfo(
    name: 'Carbonate de calcium',
    score: 1,
    description:
        'Craie naturelle utilisée comme colorant blanc ou anti-agglomérant. Sûr.',
  ),
  'E171': const AdditiveInfo(
    name: 'Dioxyde de titane',
    score: 4,
    description:
        "Nanoparticules cancérigènes potentielles. Interdit dans l'Union Européenne.",
  ),

  // === CONSERVATEURS (E200 - E299) ===
  'E200': const AdditiveInfo(
    name: 'Acide sorbique',
    score: 2,
    description:
        "Conservateur classique. Tolérable, rares cas d'allergies cutanées.",
  ),
  'E202': const AdditiveInfo(
    name: 'Sorbate de potassium',
    score: 2,
    description: 'Très fréquent. Globalement sûr aux doses autorisées.',
  ),
  'E211': const AdditiveInfo(
    name: 'Benzoate de sodium',
    score: 3,
    description:
        "Conservateur acide (boissons). Risque d'allergies et d'hyperactivité chez l'enfant.",
  ),
  'E220': const AdditiveInfo(
    name: 'Anhydride sulfureux',
    score: 3,
    description:
        'Famille des sulfites. Allergène majeur (maux de tête, asthme, digestif).',
  ),
  'E223': const AdditiveInfo(
    name: 'Disulfite de sodium',
    score: 3,
    description:
        'Sulfite. Provoque de fortes intolérances chez les personnes sensibles.',
  ),
  'E249': const AdditiveInfo(
    name: 'Nitrite de potassium',
    score: 4,
    description:
        'Conservateur des charcuteries. Favorise le risque de cancer colorectal.',
  ),
  'E250': const AdditiveInfo(
    name: 'Nitrite de sodium',
    score: 4,
    description:
        "Très toxique à long terme. Forme des nitrosamines cancérogènes dans l'estomac.",
  ),
  'E251': const AdditiveInfo(
    name: 'Nitrate de sodium',
    score: 4,
    description:
        'Se transforme partiellement en nitrites nocifs au cours du stockage et de la digestion.',
  ),
  'E252': const AdditiveInfo(
    name: 'Nitrate de potassium',
    score: 4,
    description: "Mêmes risques cancérogènes que l'E250.",
  ),

  // === ANTIOXYDANTS & ACIDIFIANTS (E300 - E399) ===
  'E300': const AdditiveInfo(
    name: 'Acide ascorbique',
    score: 1,
    description:
        'Vitamine C. Antioxydant indispensable et totalement inoffensif.',
  ),
  'E301': const AdditiveInfo(
    name: 'Ascorbate de sodium',
    score: 1,
    description: 'Sel de vitamine C. Parfaitement sûr.',
  ),
  'E306': const AdditiveInfo(
    name: 'Extraits riches en tocophérols',
    score: 1,
    description: 'Vitamine E naturelle. Excellent antioxydant protecteur.',
  ),
  'E316': const AdditiveInfo(
    name: 'Érythorbate de sodium',
    score: 2,
    description:
        'Antioxydant proche de la vitamine C mais sans activité vitaminique. Sûr.',
  ),
  'E320': const AdditiveInfo(
    name: 'Butylhydroxyanisole (BHA)',
    score: 4,
    description:
        'Perturbateur endocrinien et cancérigène possible selon le CIRC. À éviter.',
  ),
  'E322': const AdditiveInfo(
    name: 'Lécithines',
    score: 1,
    description:
        'Lécithine de soja ou de tournesol. Émulsifiant naturel inoffensif.',
  ),
  'E322I': const AdditiveInfo(
    name: 'Lécithines (brutes / standards)',
    score: 1,
    description:
        "Émulsifiant d'origine naturelle (généralement extrait de soja, de tournesol ou de colza). Totalement inoffensif pour l'organisme, c'est un constituant naturel de nos cellules. Attention toutefois aux risques d'OGM (si soja) et d'allergies chez les personnes très sensibles.",
  ),
  'E330': const AdditiveInfo(
    name: 'Acide citrique',
    score: 1,
    description:
        "Acidifiant du citron. Parfaitement inoffensif pour l'organisme.",
  ),
  'E331': const AdditiveInfo(
    name: 'Citrates de sodium',
    score: 1,
    description: "Régulateur d'acidité dérivé de l'acide citrique. Inoffensif.",
  ),
  'E339': const AdditiveInfo(
    name: 'Phosphates de sodium',
    score: 4,
    description:
        'Additif phosphaté. Risque de maladies cardiovasculaires et rénales en excès.',
  ),

  // === ÉPAISSISSANTS, GÉLIFIANTS & ÉMULSIFIANTS (E400 - E499) ===
  'E406': const AdditiveInfo(
    name: 'Agar-agar',
    score: 1,
    description: "Gélifiant naturel extrait d'algues rouges. Totalement sain.",
  ),
  'E407': const AdditiveInfo(
    name: 'Carraghénanes',
    score: 3,
    description:
        "Extrait d'algues. Suspecté de causer des inflammations du côlon.",
  ),
  'E410': const AdditiveInfo(
    name: 'Farine de graines de caroube',
    score: 1,
    description: 'Épaississant naturel végétal. Sans aucun danger.',
  ),
  'E412': const AdditiveInfo(
    name: 'Gomme de guar',
    score: 2,
    description:
        'Extrait de graine. Sûr, mais peut causer des ballonnements à forte dose.',
  ),
  'E414': const AdditiveInfo(
    name: 'Gomme arabique',
    score: 1,
    description: "Exsudat d'acacia. Naturel et sûr, agit comme une fibre.",
  ),
  'E415': const AdditiveInfo(
    name: 'Gomme xanthane',
    score: 2,
    description:
        'Issu de fermentation bactérienne. Tolérable, laxatif à forte dose.',
  ),
  'E422': const AdditiveInfo(
    name: 'Glycérol',
    score: 2,
    description:
        'Humectant (Glycérine). Sans toxicité mais apporte des calories masquées.',
  ),
  'E440': const AdditiveInfo(
    name: 'Pectines',
    score: 2,
    description:
        'Gélifiant naturel des fruits. Sûr, de rares inconforts intestinaux.',
  ),
  'E450': const AdditiveInfo(
    name: 'Diphosphates',
    score: 4,
    description:
        'Sels de phosphates. Perturbe la fixation du calcium et abîme les reins.',
  ),
  'E451': const AdditiveInfo(
    name: 'Triphosphates',
    score: 4,
    description:
        "Très fréquent dans les viandes transformées pour retenir l'eau. Toxique en excès.",
  ),
  'E452': const AdditiveInfo(
    name: 'Polyphosphates',
    score: 4,
    description: 'Mêmes risques graves liés aux surdosages en phosphates.',
  ),
  'E471': const AdditiveInfo(
    name: "Mono et diglycérides d'acides gras",
    score: 3,
    description:
        'Graisses industrielles émulsifiantes. Impact négatif suspecté sur le microbiote.',
  ),
  'E472e': const AdditiveInfo(
    name: 'Esters esters diacétyltartriques',
    score: 3,
    description:
        "Émulsifiant des pains industriels. Suspecté d'altérer la barrière intestinale.",
  ),
  'E481': const AdditiveInfo(
    name: 'Stéaroyl-2-lactylate de sodium',
    score: 3,
    description:
        'Émulsifiant et agent de traitement des farines très fréquent dans les pains de mie et viennoiseries industrielles. Suspecté de perturber la perméabilité de la barrière intestinale et de modifier le microbiote.',
  ),

  // === ANTI-AGGLOMÉRANTS & CORRECTEURS (E500 - E599) ===
  'E500': const AdditiveInfo(
    name: 'Carbonates de sodium',
    score: 1,
    description: 'Bicarbonate de soude classique. Totalement inoffensif.',
  ),
  'E503': const AdditiveInfo(
    name: "Carbonates d'ammonium",
    score: 1,
    description: 'Poudre à lever traditionnelle pour biscuits. Aucun danger.',
  ),
  'E508': const AdditiveInfo(
    name: 'Chlorure de potassium',
    score: 2,
    description:
        "Alternative au sel de table. Attention en cas d'insuffisance rénale.",
  ),
  'E551': const AdditiveInfo(
    name: 'Dioxyde de silicium',
    score: 3,
    description:
        'Anti-agglomérant contenant souvent des nanoparticules non déclarées.',
  ),

  // === EXHAUSTEURS DE GOÛT (E600 - E699) ===
  'E621': const AdditiveInfo(
    name: 'Glutamate monosodique',
    score: 3,
    description:
        "Neurotoxique potentiel. Responsable de réactions d'intolérance (maux de tête).",
  ),
  'E631': const AdditiveInfo(
    name: 'Inosinate disodique',
    score: 3,
    description:
        'Souvent couplé au glutamate. À éviter par les personnes souffrant de la goutte.',
  ),

  // === AMIDONS MODIFIÉS (E1400 - E1499) ===
  'E1422': const AdditiveInfo(
    name: "Adipate d'amidon acétylé",
    score: 2,
    description:
        'Amidon modifié chimiquement. Sûr mais signe de produits ultra-transformés.',
  ),
  'E1442': const AdditiveInfo(
    name: "Phosphate d'hydroxypropylamidon",
    score: 2,
    description:
        'Amidon modifié très fréquent dans les crèmes et sauces. Tolérable.',
  ),

  // === ÉDULCORANTS (E900 - E999) ===
  'E950': const AdditiveInfo(
    name: 'Acésulfame-K',
    score: 4,
    description:
        "Édulcorant chimique de synthèse. Suspecté d'augmenter les risques de cancers.",
  ),
  'E951': const AdditiveInfo(
    name: 'Aspartame',
    score: 4,
    description:
        "Édulcorant très controversé. Classé cancérigène possible par l'OMS.",
  ),
  'E955': const AdditiveInfo(
    name: 'Sucralose',
    score: 4,
    description:
        'Sucre chloré artificiel. Altère profondément la flore intestinale à long terme.',
  ),
  'E960': const AdditiveInfo(
    name: 'Glycosides de stéviol',
    score: 2,
    description:
        'Extrait de la plante Stévia. Meilleur que les édulcorants chimiques mais goût amer.',
  ),
  'E965': const AdditiveInfo(
    name: 'Maltitol',
    score: 2,
    description:
        'Sucre-alcool (Polyol). Sans danger mais laxatif et cause des gaz en excès.',
  ),
};
