module ActsAsEnabled
  extend ActiveSupport::Concern
  
  included do
    send(:acts_as_enabled)
  end
  
  module ClassMethods
    
    def acts_as_enabled
      scope :enabled, where(:is_enabled => true)
      scope :disabled, where(:is_enabled => [false,nil])
      after_save :trigger_observers
    end
    
    def enable_counter(belongs_to_model_name, options = {})
      after_save "#{belongs_to_model_name}_counter"
      after_destroy "#{belongs_to_model_name}_counter_destroy"
    end
    
  end
  
  module InstanceMethods
    
    def disabled?
      !is_enabled
    end
    
    def enabled?
      is_enabled
    end
    
    def enable
      update_attributes :is_enabled => true
    end
    
    def disable
      update_attributes :is_enabled => false
    end
    
    def method_missing(method_name, *args, &block)
      begin
        super
      rescue
        if method_name.to_s.index("_counter")
          update_counter(method_name.to_s.gsub("_counter", "").gsub("_destroy", ""), method_name.to_s.index("destroy"))
        else
          super
        end
      end
    end
    
    def changed_to_disabled?
      is_enabled_changed? && !is_enabled
    end
    
    def changed_to_enabled?
      is_enabled_changed? && is_enabled
    end
    
    private
    
    def trigger_observers
      notify_observers(:after_enable) if changed_to_enabled?
      notify_observers(:after_disable) if changed_to_disabled?
    end
    
    def update_counter(model_name, destroy = false)
      if is_enabled_changed? || destroy
        instance = send(model_name)
        if instance
          count = instance.send(self.class.to_s.tableize).enabled.count
          column_counter = "#{self.class.to_s.tableize}_count"
          instance.update_attribute column_counter, count
        end
      end
    end
    
  end
  
end