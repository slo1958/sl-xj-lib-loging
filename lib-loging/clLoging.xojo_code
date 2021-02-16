#tag Class
Protected Class clLoging
Implements itfLogingWriter
	#tag Method, Flags = &h21
		Private Sub add_log_entry(the_severity as string, the_time as string, the_source as string, the_message as string)
		  // TODO: implement basic writer
		  
		  System.DebugLog the_time+". " +the_severity + " " +  the_message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub add_writer(the_writer_id as string, the_writer as itfLogingWriter)
		  Dim tmp As New  internals.clLogingWriterEntry
		  
		  tmp.identity = the_writer_id
		  tmp.enabled = True
		  tmp.log_writer = the_writer
		  writers.Append(tmp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  running_tasks = new xojo.core.Dictionary
		  
		  add_writer cst_internal_writer_id, Self
		  
		  error_limit = 50
		  warning_limit = 50
		  
		  error_limit_is_fatal = False
		  send_info_message_on_warning_reset = False
		  send_info_message_on_error_reset = True
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub disable_writer(the_id as string)
		  For Each tmp As  internals.clLogingWriterEntry In writers
		    If tmp.identity = the_id Then
		      tmp.enabled = False
		      
		    End If
		    
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub enable_wrtier(the_id as string)
		  For Each tmp As  internals.clLogingWriterEntry In writers
		    If tmp.identity = the_id Then
		      tmp.enabled = True
		      
		    End If
		    
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function get_default_loging_support() As clLoging
		  If default_loging = Nil Then
		    default_loging = New clLoging
		    
		  End If
		  
		  Return default_loging
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub internal_write_item(the_severity as string, the_source as string, the_message as string)
		  Dim tmp_time As String  = Xojo.Core.Date.Now.ToText
		  
		  For Each tmp As  internals.clLogingWriterEntry In writers
		    If tmp.enabled Then
		      tmp.log_writer.add_log_entry(the_severity, tmp_time, the_source, the_message)
		      
		    End If
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function process_parameters(the_message as string, the_parameters() as Variant) As string
		  // TODO: apply formatting
		  
		  Dim tmp_return As String = the_message
		  
		  For i As Integer = 0 To the_parameters.Ubound
		    tmp_return = tmp_return.Replace("%"+Str(i), the_parameters(i))
		    
		  Next
		  
		  Return tmp_return
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub reset_error_counter()
		  error_counter = 0
		  
		  If send_info_message_on_error_reset Then
		    write_info cst_msg_error_counter_reset
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub reset_warning_counter()
		  warning_counter = 0
		  
		  If send_info_message_on_warning_reset Then
		    write_info cst_msg_warning_counter_reset
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub task_end(the_task_id As String)
		  
		  Try
		    Dim tmp As internals.clLogingTimer =  internals.clLogingTimer(running_tasks.Value(the_task_id))
		    
		    tmp.Done
		    
		    running_tasks.Remove the_task_id
		    
		    write_info cst_msg_task_end, the_task_id, Format(tmp.get_execution_time,"###,###.000")+" second(s)"
		    
		  Catch KeyNotFoundException
		    write_error cst_msg_task_not_found, the_task_id, CurrentMethodName
		    
		  End 
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub task_end_all()
		  Dim key_store() As String
		  
		  // cannot alter a Dictionary while iterating, so take a copy of the keys
		  For Each item As  Xojo.Core.DictionaryEntry In running_tasks
		    key_store.Append(item.key)
		    
		  Next
		  
		  For Each task_id As String In key_store
		    task_end task_id
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub task_start(the_task_id As String)
		  Dim tmp As New  internals.clLogingTimer(the_task_id)
		  running_tasks.value(the_task_id) = tmp
		  
		  write_info cst_msg_task_start, the_task_id
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub write_error(the_message as string, ParamArray the_parameters as variant)
		  error_counter = error_counter + 1
		  
		  If error_counter > error_limit Then
		    Return
		    
		  Elseif error_counter = error_limit Then
		    internal_write_item cst_severitty_warning, "", cst_msg_error_msg_disabled
		    
		  Else
		    internal_write_item cst_severity_error, "", process_parameters(the_message, the_parameters)
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub write_info(the_message as string, ParamArray the_parameters as Variant)
		  internal_write_item cst_severity_information, "", process_parameters(the_message, the_parameters)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub write_summary()
		  
		  write_info cst_msg_status_message, warning_counter, error_counter
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub write_warning(the_message as string, ParamArray the_parameters as variant)
		  warning_counter = warning_counter + 1
		  
		  If warning_counter > warning_limit Then
		    Return
		    
		  Elseif warning_counter = warning_limit Then
		    internal_write_item cst_severitty_warning, "", cst_msg_warning_msg_disabled
		    
		    
		  Else
		    internal_write_item cst_severitty_warning, "", process_parameters(the_message, the_parameters)
		    
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared default_loging As clLoging
	#tag EndProperty

	#tag Property, Flags = &h21
		Private error_counter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private error_limit As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return merror_limit_is_fatal_flag
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  merror_limit_is_fatal_flag = value
			End Set
		#tag EndSetter
		error_limit_is_fatal As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private merror_limit_is_fatal_flag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private msend_info_message_on_error_reset As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private msend_info_message_on_warning_reset As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		running_tasks As xojo.core.Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return msend_info_message_on_error_reset
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  msend_info_message_on_error_reset = value
			End Set
		#tag EndSetter
		send_info_message_on_error_reset As boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return msend_info_message_on_warning_reset
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  msend_info_message_on_warning_reset = value
			End Set
		#tag EndSetter
		send_info_message_on_warning_reset As boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private warning_counter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private warning_limit As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private writers() As internals.clLogingWriterEntry
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="error_limit_is_fatal"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="send_info_message_on_error_reset"
			Group="Behavior"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="send_info_message_on_warning_reset"
			Group="Behavior"
			Type="boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
