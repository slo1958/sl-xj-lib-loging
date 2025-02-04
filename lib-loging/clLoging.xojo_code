#tag Class
Protected Class clLoging
Implements itfLogingWriter
	#tag Method, Flags = &h21
		Private Sub AddLogEntry(MessageSeverity as string, MessageTime as string, MessageSource as string, MessageText as string)
		  //
		  // Internal logWriter
		  //
		  
		  if MessageSource.Length > 0 then
		    
		    System.DebugLog MessageTime+". " +MessageSeverity + " " +  MessageText + " from " + MessageSource
		    
		  else
		    System.DebugLog MessageTime+". " +MessageSeverity + " " +  MessageText
		    
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddWriter(prmWriterId as string, prmWriter as itfLogingWriter)
		  //
		  // Add a log writer
		  //
		  //
		  
		  For Each tmp As  internals.clLogingWriterEntry In writers
		    If tmp.identity = prmWriterId Then
		      WriteError cstMsgWriterAlreadyDefined, prmWriterId
		      return
		      
		    End If
		    
		  Next
		  
		  var tmp As New  internals.clLogingWriterEntry(prmWriterId, prmWriter)
		  
		  writers.Append(tmp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearAllMethods()
		  self.TrackedMethods = new Dictionary
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  RunningTasks = new Dictionary
		  self.TrackedMethods = new Dictionary
		  
		  AddWriter cstInternalWriterId, Self
		  
		  error_limit = 50
		  warning_limit = 50
		  
		  ErrorLimitIsFatal = False
		  SendInfoMessageOnWarningReset = False
		  SendInfoMessageOnErrorReset = True
		  
		  FormatForNumberParam = cDefaultFormatNumberParam
		  
		  FormatForExecutionTime = cDefaultFormatExecutionTime
		  
		  self.AcceptedSeverity = new Dictionary
		  
		  Self.AcceptedSeverity.Value(cstSeverityFatalError) = true
		  Self.AcceptedSeverity.Value(cstSeverityError) = true
		  Self.AcceptedSeverity.Value(cstSeverityWarning) = true 
		  self.AcceptedSeverity.Value(cstSeverityInformation) = true
		  self.AcceptedSeverity.Value(cstSeverityStatistics) = True
		  
		  Return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisableWriter(prmWriterId as string = cstInternalWriterId)
		  //
		  // Disable a specific writers
		  // 
		  // Parameters:
		  // - Identifier of the writer to be disabled
		  //
		  // Returns:
		  // (nothing)
		  //
		  For Each tmp As  internals.clLogingWriterEntry In writers
		    If tmp.identity = prmWriterId Then
		      tmp.enabled = False
		      return
		      
		    End If
		    
		  Next
		  
		  WriteError cstMsgWriterNotFound, prmWriterId
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnableWriter(prmWriterId as string = cstInternalWriterId)
		  //
		  // Enable a specific writers
		  // 
		  // Parameters:
		  // - Identifier of the writer to be enabled
		  //
		  // Returns:
		  // (nothing)
		  //
		  For Each tmp As  internals.clLogingWriterEntry In writers
		    If tmp.identity = prmWriterId Then
		      tmp.enabled = True
		      return
		      
		    End If
		    
		  Next
		  
		  
		  WriteError cstMsgWriterNotFound, prmWriterId
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EnterMethod(MethodName as string)
		  
		  var methodInfo as internals.clMethodTimer = self.TrackedMethods.Lookup(MethodName, nil)
		  
		  if methodInfo = nil then 
		    methodInfo = new  internals.clMethodTimer(MethodName)
		    self.TrackedMethods.Value(MethodName) = methodInfo
		    
		  end if
		  
		  methodInfo.EnterMethod
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExitMethod(MethodName as string)
		  
		  var methodInfo as internals.clMethodTimer = self.TrackedMethods.Lookup(MethodName, nil)
		  
		  if methodInfo <> nil then methodInfo.ExitMethod
		  
		  
		  
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
		Private Function internal_ProcessParameters(MessageText as string, the_parameters() as Variant) As string
		  // TODO: apply formatting
		  
		  var tmp_return As String = MessageText
		  
		  For i As Integer = 0 To the_parameters.Ubound
		    var formattedParam as string
		    
		    select case the_parameters(i).Type
		      
		    case Variant.TypeDouble
		      formattedParam = str(the_parameters(i).DoubleValue, self.FormatForNumberParam)
		      
		    case Variant.TypeDateTime
		      formattedParam = the_parameters(i).DateTimeValue.SQLDateTime
		      
		    case else
		      formattedParam = the_parameters(i)
		      
		    end select
		    
		    tmp_return = tmp_return.Replace("%"+Str(i), formattedParam)
		    
		  Next
		  
		  Return tmp_return
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub internal_WriteItem(MessageSeverity as string, MessageSource as string, MessageText as string)
		  
		  if self.AcceptedSeverity.Value(MessageSeverity) then
		    
		    var TimeStamp As String  = DateTime.Now.SQLDateTime
		    
		    For Each Writer As  internals.clLogingWriterEntry In writers
		      If Writer.enabled Then
		        Writer.log_writer.AddLogEntry(MessageSeverity, TimeStamp, MessageSource, MessageText)
		        
		      End If
		      
		    Next
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MethodStats(MethodName as string)
		  
		  var methodInfo as internals.clMethodTimer = self.TrackedMethods.Lookup(MethodName, nil)
		  
		  if methodInfo <> nil then  
		    var p as pair = methodInfo.MethodStats
		    
		    var count as integer = p.left
		    var tottime as double = p.Right
		    var itertime as double = if(count <= 0, 0, tottime / count)
		    
		    WriteStatistics cstMsgMethodStats, MethodName, count, format(tottime, FormatForExecutionTime) , format(itertime, FormatForExecutionTime)
		    
		  else
		    
		  end if
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MethodStatsAll()
		  
		  for each method as string in self.TrackedMethods.keys
		    self.MethodStats(method)
		    
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetErrorCounter()
		  //
		  // Reset the error counter
		  //
		  // Parameters
		  // (nothing)
		  // 
		  // Returns
		  // (nothing)
		  
		  self.error_counter = 0
		  
		  If SendInfoMessageOnErrorReset Then
		    WriteInfo cstMsgResetErrorCounter
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetWarningCounter()
		  //
		  // Reset the warning counter
		  //
		  // Parameters
		  // (nothing)
		  // 
		  // Returns
		  // (nothing)
		  //
		  self.warning_counter = 0
		  
		  If SendInfoMessageOnWarningReset Then
		    WriteInfo cstMsgResetWarningCounter
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetErrorLimit(NewLimit as integer)
		  //
		  // Update the error limit. The error lmit is the maximum number of error messages since the last reset that
		  // will be forwarded to the writers.
		  //
		  // Parameters:
		  // - new error limit
		  //
		  // Returns:
		  // (nothing)
		  //
		  self.error_limit = NewLimit
		  
		  WriteInfo cstMsgSetErrorLimit, NewLimit
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFormatForExecutionTime(prmFormat as string)
		  self.FormatForExecutionTime = prmFormat
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFormatForNumbers(prmFormat as string)
		  self.FormatForNumberParam = prmFormat
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetWarningLimit(NewLimit as integer)
		  //
		  // Update the warning limit. The warning limit is the maximum number of warning messages since the last reset that
		  // will be forwarded to the writers.
		  //
		  // Parameters:
		  // - new warning limit
		  //
		  // Returns:
		  // (nothing)
		  //
		  
		  self.warning_limit = NewLimit
		  
		  WriteInfo cstMsgSetWarningLimit, self.warning_limit
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TaskEnd(pTaskId As String)
		  
		  
		  var tmp As internals.clLogingTaskTimer =  internals.clLogingTaskTimer(RunningTasks.Lookup(pTaskId, nil))
		  
		  if tmp = nil then
		    WriteError cstMsgTaskNotFound, pTaskId, CurrentMethodName
		    
		  else
		    tmp.Done
		    
		    RunningTasks.Remove(pTaskId)
		    
		    WriteInfo cstMsgTaskEnd, pTaskId, Format(tmp.GetExecutionTime, FormatForExecutionTime) 
		    
		  end if
		  
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
		  For Each item As  string In RunningTasks.keys
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
		  
		  var tmp As New  internals.clLogingTaskTimer(pTaskId)
		  RunningTasks.value(pTaskId) = tmp
		  
		  WriteInfo cstMsgTaskStart, pTaskId
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSeverityFilter(SeverityLevel as string, AllowOutput as Boolean)
		  //
		  // Update the severity filter on severity level
		  // This filter is applied before forwarding messages to all writers
		  // This is a global filter. Each individual writer may also support a filtering mechanism.
		  //
		  // Parameters:
		  // - severity level 
		  // - enabled/ disable forwarding message of the given severity to the writers
		  //
		  // Returns:
		  // (nothing)
		  //
		  self.AcceptedSeverity.Value(SeverityLevel) = AllowOutput
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteError(MessageText as string, ParamArray the_parameters as variant)
		  //
		  // Write an error message
		  // The message may contain place holder %0, %1, ... replaced by corresponding parameters
		  // Error messages are fowarded to writers until the maximum error count is reached.
		  // The internal counter reflects the actual number of calls to WriteError()
		  //
		  // Parameters
		  // - Message template
		  // - List of parameters
		  //
		  // Returns:
		  // (nothing)
		  //
		  
		  self.error_counter = self.error_counter + 1
		  
		  If self.error_counter > self.error_limit Then
		    Return
		    
		  Elseif self.error_counter =self.error_limit Then
		    If ErrorLimitIsFatal Then
		      writeFatalError cstMsgReachedErrorLimit, error_limit
		      
		    Else
		      internal_WriteItem cstSeverityWarning, "", cstMsgErrorMsgDisabled
		      
		    End If
		    
		  Else
		    internal_WriteItem cstSeverityError, "", internal_ProcessParameters(MessageText, the_parameters)
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteFatalError(MessageText as string, ParamArray the_parameters as variant)
		  //
		  // Write a fatal error message
		  // The message may contain place holder %0, %1, ... replaced by corresponding parameters. Processing stops after sending the message to all writers.
		  //
		  // Parameters
		  // - Message template
		  // - List of parameters
		  //
		  // Returns:
		  // (nothing)
		  //
		  
		  internal_WriteItem cstSeverityFatalError, "", internal_ProcessParameters(MessageText, the_parameters)
		  
		  Quit -1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteInfo(MessageText as string, ParamArray the_parameters as Variant)
		  //
		  // Write an information message
		  // The message may contain place holder %0, %1, ... replaced by corresponding parameters
		  //
		  // Parameters
		  // - Message template
		  // - List of parameters
		  //
		  // Returns:
		  // (nothing)
		  //
		  internal_WriteItem cstSeverityInformation, "", internal_ProcessParameters(MessageText, the_parameters)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteStatistics(MessageText as string, ParamArray the_parameters as Variant)
		  //
		  // Write an information message
		  // The message may contain place holder %0, %1, ... replaced by corresponding parameters
		  //
		  // Parameters
		  // - Message template
		  // - List of parameters
		  //
		  // Returns:
		  // (nothing)
		  //
		  internal_WriteItem cstSeverityStatistics, "", internal_ProcessParameters(MessageText, the_parameters)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteSummary()
		  //
		  // Send the number of calls to WriteWarning and WriteError 
		  // As an information message
		  //
		  // Parameters:
		  // (nothing)
		  //
		  // Returns:
		  // (nothing)
		  //
		  WriteInfo cstMsgStatusMessage, warning_counter, error_counter
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WriteWarning(MessageText as string, ParamArray the_parameters as variant)
		  //
		  // Write an warning message
		  // The message may contain place holder %0, %1, ... replaced by corresponding parameters
		  // Warning messages are fowarded to writers until the maximum warning count is reached.
		  // The internal counter reflects the actual number of calls to WriteWarning()
		  //
		  // Parameters
		  // - Message template
		  // - List of parameters
		  //
		  // Returns:
		  // (nothing)
		  //
		  self.warning_counter = self.warning_counter + 1
		  
		  If self.warning_counter > self.warning_limit Then
		    Return
		    
		  Elseif self.warning_counter = self.warning_limit Then
		    internal_WriteItem cstSeverityWarning, "", cstMsgWarningMsgDisabled
		    
		    
		  Else
		    internal_WriteItem cstSeverityWarning, "", internal_ProcessParameters(MessageText, the_parameters)
		    
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AcceptedSeverity As Dictionary
	#tag EndProperty

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
		Private FormatForExecutionTime As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FormatForNumberParam As string
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

	#tag Property, Flags = &h21
		Private RunningTasks As Dictionary
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
		Private TrackedMethods As Dictionary
	#tag EndProperty

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
