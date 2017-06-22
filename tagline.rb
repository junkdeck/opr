module Tagline
  def self.tagline_generator
    tags = [
      "chunky",
      "family style",
      "vintage time waster",
      "roguelite puzzler",
      "desperate scramble for a portfolio piece",
      "Y2K compliant",
      "never-seen-before",
      "illustrious career all started with",
      "diet contains natural sources of",
      "chopped & screwed",
      "proud to present",
      "sick and tired of",
      "original recipe",
      "visually impressive",
      "dangerously spicy",
      "hot and heavy",
      "interdimensional nosedive",
      "curio of the millenium",
      "straight out the oven",
      "sparkly and clean",
      "sweet, sweet",
      "homemade",
      "jerry-rigged",
      "barely functional",
      "multi-player only",
      "early access",
      "crowdfunded",
      "carrot-top of cli entertainment",
      "enterprise-level server infrastructure framework",
      "Brand New",
      "dynamic tagline generated",
      "personal warning: do not operate heavy machinery after using",
      "ruby implementation of tic-tac-toe",
      "journey to the planet named",
      ""
    ]
    tag = rand(0..tags.length+1)
    return tags[tag]
  end
end
