//
// NetworkError.swift
//
//
// Created by GolanBar-Nov on 11/04/2024.
//

import Foundation

public struct NetworkError: Error, Decodable, Hashable {
    public let code: Int
    public let message: String
    
    private enum CodingKeys: String, CodingKey {
        case code = "status_code", message = "status_message"
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}

// The movie DB errors (developer.themoviedb.org/docs/errors)
extension NetworkError {
    static let invalidService = NetworkError(code: 2, message: "Invalid service: this service does not exist.")
    static let noPermissions = NetworkError(code: 3, message: "Authentication failed: You do not have permissions to access the service.")
    static let invalidFormat = NetworkError(code: 4, message: "Invalid format: This service doesn't exist in that format.")
    static let invalidParameters = NetworkError(code: 5, message: "Invalid parameters: Your request parameters are incorrect.")
    static let missingID = NetworkError(code: 6, message: "Invalid id: The pre-requisite id is invalid or not found.")
    static let invalidApiKey = NetworkError(code: 7, message: "Invalid API key: You must be granted a valid key.")
    static let duplicateEntry = NetworkError(code: 8, message: "Duplicate entry: The data you tried to submit already exists.")
    static let serviceOffline = NetworkError(code: 9, message: "Service offline: This service is temporarily offline, try again later.")
    static let suspendedApiKey = NetworkError(code: 10, message: "Suspended API key: Access to your account has been suspended, contact TMDB.")
    static let internalError = NetworkError(code: 11, message: "Internal error: Something went wrong, contact TMDB.")
    static let itemUpdated = NetworkError(code: 12, message: "The item/record was updated successfully.")
    static let itemDeleted = NetworkError(code: 13, message: "The item/record was deleted successfully.")
    static let authenticationFailed = NetworkError(code: 14, message: "Authentication failed.")
    static let failed = NetworkError(code: 15, message: "Failed.")
    static let deviceDenied = NetworkError(code: 16, message: "Device denied.")
    static let sessionDenied = NetworkError(code: 17, message: "Session denied.")
    static let validationFailed = NetworkError(code: 18, message: "Validation failed.")
    static let invalidAcceptHeader = NetworkError(code: 19, message: "Invalid accept header.")
    static let invalidDateRange = NetworkError(code: 20, message: "Invalid date range: Should be a range no longer than 14 days.")
    static let entryNotFound = NetworkError(code: 21, message: "Entry not found: The item you are trying to edit cannot be found.")
    static let invalidPage = NetworkError(code: 22, message: "Invalid page: Pages start at 1 and max at 500. They are expected to be an integer.")
    static let invalidDateFormat = NetworkError(code: 23, message: "Invalid date: Format needs to be YYYY-MM-DD.")
    static let timedOut = NetworkError(code: 24, message: "Your request to the backend server timed out. Try again.")
    static let requestCountIsOverTheAllowedLimit = NetworkError(code: 25, message: "Your request count (#) is over the allowed limit of (40).")
    static let usernameAndPasswordRequired = NetworkError(code: 26, message: "You must provide a username and password.")
    static let appendToResponseObjectsExceeded = NetworkError(code: 27, message: "Too many append to response objects: The maximum number of remote calls is 20.")
    static let invalidTimezone = NetworkError(code: 28, message: "Invalid timezone: Please consult the documentation for a valid timezone.")
    static let parameterConfirmationRequired = NetworkError(code: 29, message: "You must confirm this action: Please provide a confirm=true parameter.")
    static let invalidUsernameOrPassword = NetworkError(code: 30, message: "Invalid username and/or password: You did not provide a valid login.")
    static let accountDisabled = NetworkError(code: 31, message: "Account disabled: Your account is no longer active. Contact TMDB if this is an error.")
    static let emailNotVerified = NetworkError(code: 32, message: "Email not verified: Your email address has not been verified.")
    static let invalidRequestToken = NetworkError(code: 33, message: "Invalid request token: The request token is either expired or invalid.")
    static let resourceNotFound = NetworkError(code: 34, message: "The resource you requested could not be found.")
    static let invalidToken = NetworkError(code: 35, message: "Invalid token.")
    static let writePermissionNotGranted = NetworkError(code: 36, message: "This token hasn't been granted write permission by the user.")
    static let requestedSessionNotFound = NetworkError(code: 37, message: "The requested session could not be found.")
    static let noEditPermissions = NetworkError(code: 38, message: "You don't have permission to edit this resource.")
    static let resourceIsPrivate = NetworkError(code: 39, message: "This resource is private.")
    static let nothingToUpdate = NetworkError(code: 40, message: "Nothing to update.")
    static let requestTokenNotApproved = NetworkError(code: 41, message: "This request token hasn't been approved by the user.")
    static let methodNotSupported = NetworkError(code: 42, message: "This request method is not supported for this resource.")
    static let connectionFailed = NetworkError(code: 43, message: "Couldn't connect to the backend server.")
    static let invalidID = NetworkError(code: 44, message: "The ID is invalid.")
    static let userSuspended = NetworkError(code: 45, message: "This user has been suspended.")
    static let underMaintenance = NetworkError(code: 46, message: "The API is undergoing maintenance. Try again later.")
    static let invalidInput = NetworkError(code: 47, message: "The input is not valid.")
}
