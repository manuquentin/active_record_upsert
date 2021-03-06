# module ActiveRecordUpsert
#   module Arel
#     module CrudExtensions
#       def create_on_conflict_do_update
#         OnConflictDoUpdateManager.new
#       end
#     end
#
#     ::Arel::Crud.prepend(CrudExtensions)
#   end
# end
module Arel
  module Crud
    def compile_upsert(upsert_keys, upsert_values, insert_values, wheres)
      on_conflict_do_update = OnConflictDoUpdateManager.new

      on_conflict_do_update.target = self[upsert_keys.join(',')]
      on_conflict_do_update.wheres = wheres
      on_conflict_do_update.set(upsert_values)

      insert_manager = create_insert
      insert_manager.on_conflict = on_conflict_do_update.to_node
      insert_manager.into insert_values.first.first.relation
      insert_manager.insert(insert_values)
      insert_manager
    end
  end
end
