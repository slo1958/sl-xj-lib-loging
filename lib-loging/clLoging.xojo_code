#tag Class
Protected Class clLoging
Implements itfLogingWriter
	#tag Method, Flags = &h21
		Private Sub AddLogEntry(the_severity as string, the_time as string, the_source as string, the_message as string)
		  // TODO: implement basic writer
		  
		  System.DebugLog the_time+". " +the_severity + " " +  the_message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddWriter(the_writer_id as string, the_writer as itfLogingWriter)
		  var tmp As New  internals.clLogingWriterEntry
		  
		  tmp.identity = the_writer_id
		  tmp.enabled = True
		  tmp.log_writer = the_writer
		  writers.Append(tmp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  running_tasks = new Dictionary
		  AddWriter cstInternalWriterId, Self
		  
		  error_limit = 50
		  warning_limit = 50
		  
		  ErrorLimitIsFatal = False
		  SendInfoMessageOnWarningReset = False
		  SendInfoMessageOnErrorReset = True
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisableWriter(the_id as string)
		  
		  For Each tmp As  internals.clLogingWriterEntry In writers
		    If tmp.identity = the_id Then
		      tmp.enabled = False
		      
		    End If
		    
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableWriter(the_id as string)
		  
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
		Private Function internal_ProcessParameters(the_message as string, the_parameters() as Variant) As string
		  // TODO: apply formatting
		  
		  var tmp_return As String = the_message
		  
		  For i As Integer = 0 To the_parameters.Ubound
		    tmp_return = tmp_return.Replace("%"+Str(i), the_parameters(i))
		    
		  Next
		  
		  Return tmp_return
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub internal_WriteItem(the_severity as string, the_source as string, the_message as string)
		  var tmp_time As String  = DateTime.Now.SQLDateTime
		  
		  For Each tmp As  internals.clLogingWriterEntry In writers
		    If tmp.enabled Then
		      tmp.log_writer.AddLogEntry(the_severity, tmp_time, the_source, the_message)
		      
		    End If
		    
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetErrorCounter()
		  error_counter = 0
		  
		  If SendInfoMessageOnErrorReset Then
		    WriteInfo cstMsgResetErrorCounter
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetWarningCounter()
		  warning_counter = 0
		  
		  If SendInfoMessageOnWarningReset Then
		    WriteInfo cstMsgResetWarningCounter
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetErrorLimit(the_limit as integer)
		  error_limit = the_limit
		  
		  WriteInfo cstMsgSetErrorLimit, error_limit
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetWarningLimit(the_limit as integer)
		  warning_limit = the_limit
		  
		  WriteInfo cstMsgSetWarningLimit, warning_limit
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TaskEnd(pTaskId As String)
		  
		  Try
		    var tmp As internals.clLogingTimer =  internals.clLogingTimer(running_tasks.Value(pTaskId))
		    
		    tmp.Done
		    
		    running_tasks.Remove(pTaskId)
		    
		    WriteInfo cstMsgTaskEnd, pTaskId, Format(tmp.GetExecutionTime,"###,###.000")+" second(s)"
		    
		  Catch KeyNotFoundException
		    WriteError cstMsgTaskNotFound, pTaskId, CurrentMethodName
		    
		  End 
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TaskEndAll()
		  //
		  // End all tasks
		  //
		  // Parameters:
		  // (nothing)
		  //
		  // Returns:
		  // (nothing)
		  //
		  
		  var key_store() As String
		  
		  // cannot alter a Dictionary while iterating, so take a copy of the keys
		  For Each item As  string In running_tasks.keys
		    key_store.Append(item)
		    
		  Next
		  
		  For Each task_id As String In key_store
		    TaskEnd task_id
		    
		  Next
		  
		  Return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TaskStart(pTaskId As String)
		  var tmp As New  internals.clLogingTimer(pTaskId)
		  running_tasks.value(pTaskId) = tmp
		  
		  WriteInfo cstMsgTaskStart, pTaskId
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteError(the_message as string, ParamArray the_parameters as variant)
		  error_counter = error_counter + 1
		  
		  If error_counter > error_limit Then
		    Return
		    
		  Elseif error_counter = error_limit Then
		    If ErrorLimitIsFatal Then
		      writeFatalError cstMsgReachedErrorLimit, error_limit
		      
		    Else
		      internal_WriteItem cstSeverityWarning, "", cstMsgErrorMsgDisabled
		      
		    End If
		    
		  Else
		    internal_WriteItem cstSeverityError, "", internal_ProcessParameters(the_message, the_parameters)
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteFatalError(the_message as string, ParamArray the_parameters as variant)
		  
		  internal_WriteItem cstSeverityFatalError, "", internal_ProcessParameters(the_message, the_parameters)
		  
		  Quit -1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteInfo(the_message as string, ParamArray the_parameters as Variant)
		  internal_WriteItem cstSeverityInformation, "", internal_ProcessParameters(the_message, the_parameters)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteSummary()
		  
		  WriteInfo cstMsgStatusMessage, warning_counter, error_counter
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteWarning(the_message as string, ParamArray the_parameters as variant)
		  warning_counter = warning_counter + 1
		  
		  If warning_counter > warning_limit Then
		    Return
		    
		  Elseif warning_counter = warning_limit Then
		    internal_WriteItem cstSeverityWarning, "", cstMsgWarningMsgDisabled
		    
		    
		  Else
		    internal_WriteItem cstSeverityWarning, "", internal_ProcessParameters(the_message, the_parameters)
		    
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared default_loging As clLoging
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mErrorLimitIsFatal_flag
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mErrorLimitIsFatal_flag = value
			End Set
		#tag EndSetter
		ErrorLimitIsFatal As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private error_counter As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private error_limit As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mErrorLimitIsFatal_flag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSendInfoMessageOnErrorReset As boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSendInfoMessageOnWarningReset As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		running_tasks As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mSendInfoMessageOnErrorReset
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSendInfoMessageOnErrorReset = value
			End Set
		#tag EndSetter
		SendInfoMessageOnErrorReset As boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mSendInfoMessageOnWarningReset
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSendInfoMessageOnWarningReset = value
			End Set
		#tag EndSetter
		SendInfoMessageOnWarningReset As boolean
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
			Name="ErrorLimitIsFatal"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SendInfoMessageOnErrorReset"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SendInfoMessageOnWarningReset"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
