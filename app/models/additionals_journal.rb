class AdditionalsJournal
  class << self
    def save_journal_history(journal, prop_key, ids_old, ids)
      ids_all = (ids_old + ids).uniq

      ids_all.each do |id|
        next if ids_old.include?(id) && ids.include?(id)

        if ids.include?(id)
          value = id
          old_value = nil
        else
          old_value = id
          value = nil
        end

        journal.details << JournalDetail.new(property: 'attr',
                                             prop_key: prop_key,
                                             old_value: old_value,
                                             value: value)
        journal.save
      end

      true
    end

    def validate_relation(entries, entry_id)
      old_entries = entries.select { |entry| entry.id.present? }
      new_entries = entries.select { |entry| entry.id.blank? }
      return true if new_entries.blank?

      new_entries.map! { |entry| entry.send(entry_id) }
      return false if new_entries.count != new_entries.uniq.count

      old_entries.map! { |entry| entry.send(entry_id) }
      return false unless (old_entries & new_entries).count.zero?

      true
    end
  end
end
