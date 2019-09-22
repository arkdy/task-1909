class Timezone < ApplicationRecord
  enum world_region: { us: 1, europe: 2, asia: 3 }

  def to_s
    name
  end
end
