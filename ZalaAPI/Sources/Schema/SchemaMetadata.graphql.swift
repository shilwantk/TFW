// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ZalaAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ZalaAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ZalaAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ZalaAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "AddressesEmail": return ZalaAPI.Objects.AddressesEmail
    case "AddressesPhone": return ZalaAPI.Objects.AddressesPhone
    case "AddressesStreet": return ZalaAPI.Objects.AddressesStreet
    case "AddressesURL": return ZalaAPI.Objects.AddressesURL
    case "Agreement": return ZalaAPI.Objects.Agreement
    case "AgreementConnection": return ZalaAPI.Objects.AgreementConnection
    case "Answer": return ZalaAPI.Objects.Answer
    case "AnswerNote": return ZalaAPI.Objects.AnswerNote
    case "Application": return ZalaAPI.Objects.Application
    case "ApplicationMutations": return ZalaAPI.Objects.ApplicationMutations
    case "ApplicationQueries": return ZalaAPI.Objects.ApplicationQueries
    case "Appointment": return ZalaAPI.Objects.Appointment
    case "AppointmentCancelPayload": return ZalaAPI.Objects.AppointmentCancelPayload
    case "AppointmentConnection": return ZalaAPI.Objects.AppointmentConnection
    case "AppointmentCreatePayload": return ZalaAPI.Objects.AppointmentCreatePayload
    case "Assessment": return ZalaAPI.Objects.Assessment
    case "AssessmentConnection": return ZalaAPI.Objects.AssessmentConnection
    case "Attachment": return ZalaAPI.Objects.Attachment
    case "AttachmentCreatePayload": return ZalaAPI.Objects.AttachmentCreatePayload
    case "AttachmentRemovePayload": return ZalaAPI.Objects.AttachmentRemovePayload
    case "CarePlan": return ZalaAPI.Objects.CarePlan
    case "CarePlanAcceptPayload": return ZalaAPI.Objects.CarePlanAcceptPayload
    case "CarePlanAssignPayload": return ZalaAPI.Objects.CarePlanAssignPayload
    case "CarePlanCompletePayload": return ZalaAPI.Objects.CarePlanCompletePayload
    case "CarePlanContributor": return ZalaAPI.Objects.CarePlanContributor
    case "CarePlanCreatePayload": return ZalaAPI.Objects.CarePlanCreatePayload
    case "ComplianceScore": return ZalaAPI.Objects.ComplianceScore
    case "DataValue": return ZalaAPI.Objects.DataValue
    case "DataValueConnection": return ZalaAPI.Objects.DataValueConnection
    case "DataValueSource": return ZalaAPI.Objects.DataValueSource
    case "Device": return ZalaAPI.Objects.Device
    case "DeviceRegisterPayload": return ZalaAPI.Objects.DeviceRegisterPayload
    case "DeviceUnregisterPayload": return ZalaAPI.Objects.DeviceUnregisterPayload
    case "Error": return ZalaAPI.Objects.Error_Object
    case "HealthNote": return ZalaAPI.Objects.HealthNote
    case "HealthNoteSection": return ZalaAPI.Objects.HealthNoteSection
    case "HealthOrder": return ZalaAPI.Objects.HealthOrder
    case "HealthOrderSection": return ZalaAPI.Objects.HealthOrderSection
    case "HealthSnap": return ZalaAPI.Objects.HealthSnap
    case "HealthSnapConnection": return ZalaAPI.Objects.HealthSnapConnection
    case "InsuranceCard": return ZalaAPI.Objects.InsuranceCard
    case "InsuranceCarrier": return ZalaAPI.Objects.InsuranceCarrier
    case "InsurancePlan": return ZalaAPI.Objects.InsurancePlan
    case "MessagingConversation": return ZalaAPI.Objects.MessagingConversation
    case "MessagingMessage": return ZalaAPI.Objects.MessagingMessage
    case "MessagingParticipant": return ZalaAPI.Objects.MessagingParticipant
    case "Metric": return ZalaAPI.Objects.Metric
    case "MetricMonitor": return ZalaAPI.Objects.MetricMonitor
    case "Module": return ZalaAPI.Objects.Module
    case "OrgModule": return ZalaAPI.Objects.OrgModule
    case "Organization": return ZalaAPI.Objects.Organization
    case "OrganizationConnection": return ZalaAPI.Objects.OrganizationConnection
    case "PageInfo": return ZalaAPI.Objects.PageInfo
    case "Preference": return ZalaAPI.Objects.Preference
    case "Provider": return ZalaAPI.Objects.Provider
    case "ProviderConnection": return ZalaAPI.Objects.ProviderConnection
    case "ProviderNonWorkTime": return ZalaAPI.Objects.ProviderNonWorkTime
    case "RideDriver": return ZalaAPI.Objects.RideDriver
    case "RideRequest": return ZalaAPI.Objects.RideRequest
    case "Role": return ZalaAPI.Objects.Role
    case "Room": return ZalaAPI.Objects.Room
    case "Score": return ZalaAPI.Objects.Score
    case "Scorer": return ZalaAPI.Objects.Scorer
    case "Service": return ZalaAPI.Objects.Service
    case "ServiceDaySchedule": return ZalaAPI.Objects.ServiceDaySchedule
    case "ServiceQueueEntry": return ZalaAPI.Objects.ServiceQueueEntry
    case "StatusChange": return ZalaAPI.Objects.StatusChange
    case "Symptom": return ZalaAPI.Objects.Symptom
    case "Task": return ZalaAPI.Objects.Task
    case "TaskActivatePayload": return ZalaAPI.Objects.TaskActivatePayload
    case "TaskCancelPayload": return ZalaAPI.Objects.TaskCancelPayload
    case "TaskCompletePayload": return ZalaAPI.Objects.TaskCompletePayload
    case "TaskCreatePayload": return ZalaAPI.Objects.TaskCreatePayload
    case "TaskInterval": return ZalaAPI.Objects.TaskInterval
    case "TaskIntervalCompletePayload": return ZalaAPI.Objects.TaskIntervalCompletePayload
    case "TaskRemovePayload": return ZalaAPI.Objects.TaskRemovePayload
    case "User": return ZalaAPI.Objects.User
    case "UserAddDataPayload": return ZalaAPI.Objects.UserAddDataPayload
    case "UserConnection": return ZalaAPI.Objects.UserConnection
    case "UserCreatePayload": return ZalaAPI.Objects.UserCreatePayload
    case "UserEvent": return ZalaAPI.Objects.UserEvent
    case "UserLoginPayload": return ZalaAPI.Objects.UserLoginPayload
    case "UserNote": return ZalaAPI.Objects.UserNote
    case "UserNotification": return ZalaAPI.Objects.UserNotification
    case "UserNotificationConnection": return ZalaAPI.Objects.UserNotificationConnection
    case "UserNotificationCreatePayload": return ZalaAPI.Objects.UserNotificationCreatePayload
    case "UserNotificationMarkReadPayload": return ZalaAPI.Objects.UserNotificationMarkReadPayload
    case "UserNotificationRemovePayload": return ZalaAPI.Objects.UserNotificationRemovePayload
    case "UserRequestPasswordResetPayload": return ZalaAPI.Objects.UserRequestPasswordResetPayload
    case "UserUpdatePayload": return ZalaAPI.Objects.UserUpdatePayload
    case "Viewing": return ZalaAPI.Objects.Viewing
    case "WorkoutActivity": return ZalaAPI.Objects.WorkoutActivity
    case "WorkoutCategory": return ZalaAPI.Objects.WorkoutCategory
    case "WorkoutPlan": return ZalaAPI.Objects.WorkoutPlan
    case "WorkoutPlanConnection": return ZalaAPI.Objects.WorkoutPlanConnection
    case "WorkoutPlanGroup": return ZalaAPI.Objects.WorkoutPlanGroup
    case "WorkoutPlanGroupActivity": return ZalaAPI.Objects.WorkoutPlanGroupActivity
    case "WorkoutRoutine": return ZalaAPI.Objects.WorkoutRoutine
    case "WorkoutRoutineConnection": return ZalaAPI.Objects.WorkoutRoutineConnection
    case "WorkoutRoutineUpdatePayload": return ZalaAPI.Objects.WorkoutRoutineUpdatePayload
    case "WorkoutSet": return ZalaAPI.Objects.WorkoutSet
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
