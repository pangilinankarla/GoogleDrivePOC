//
//  GoogleDriveService.swift
//  GoogleDrivePOC
//
//  Created by Karla Pangilinan on 7/28/22.
//

import Foundation
import GoogleAPIClientForREST

protocol GoogleDriveAuthorizer: AnyObject {
  func setAuthorizer(_ authorizer: GTMFetcherAuthorizationProtocol?)
}

class GoogleDriveService: GoogleDriveAuthorizer {
  static let shared = GoogleDriveService()
  private let service = GTLRDriveService()
  // Add a GTLRDriveService instance variable that will be responsible for making Google Drive API requests (e.g., uploading files and listing folders).
  
  private init() {}
  
  func setAuthorizer(_ authorizer: GTMFetcherAuthorizationProtocol?) {
    service.authorizer = authorizer
  }

  func uploadFile(
    name: String,
//    folderID: String,
    fileURL: URL,
    mimeType: String//,
//    service: GTLRDriveService
  ) {
      let file = GTLRDrive_File()
      file.name = name
//      file.parents = [folderID]
      
      // Optionally, GTLRUploadParameters can also be created with a Data object.
      let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)
      
      let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)

//    let q = GTLRDriveQuery_PermissionsUpdate.
//    GTLRDriveQuery_PermissionsCreate
//    GTLRDriveQuery_PermissionsGet
//    GTLRDriveQuery_PermissionsList
      
      service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
        // This block is called multiple times during upload and can
        // be used to update a progress indicator visible to the user.
        print(". Uploading... [\(totalBytesUploaded) bytes / \(totalBytesExpectedToUpload) bytes]")
      }
      
      service.executeQuery(query) { (_, result, error) in
        guard error == nil else {
          fatalError(error!.localizedDescription)
        }
        
        // Successful upload if no error is returned.
        print("\nUPLOAD SUCCESS!\nresult:\n")
        dump(result as? GTLRDrive_File)
//      https://drive.google.com/file/d/1mSesyfz0T3Xyfrx78jHjMIXd9FvVE0z2/view
//      https://drive.google.com/file/d/1UMz_c0P0531pvcuS1PX3OaahxVfUgFTW/view
//      https://drive.google.com/file/d/1WfhT5FBW78QNvGgjar3XDeX_82qQH6Uk/view
      }

//    let newPermission = GTLDrivePermission.init()
//    GTLDrivePermission *newPermission = [GTLDrivePermission object];
//    // User or group e-mail address, domain name or nil for @"default" type.
//    newPermission.value = value;
//    // The value @"user", @"group", @"domain" or @"default".
//    newPermission.type = type;
//    // The value @"owner", @"writer" or @"reader".
//    newPermission.role = role;
//
//    GTLQueryDrive *query =
//    [GTLQueryDrive queryForPermissionsInsertWithObject:newPermission
//                                                fileId:fileId];
//    // queryTicket can be used to track the status of the request.
//    GTLServiceTicket *queryTicket =
//    [service executeQuery:query
//        completionHandler:^(GTLServiceTicket *ticket,
//                            GTLDrivePermission *permission, NSError *error) {
//      if (error == nil) {
//        completionBlock(permission, nil);
//      } else {
//        NSLog(@"An error occurred: %@", error);
//        completionBlock(nil, error);
//      }
//    }];
    }

  // TODO: ❗️ Permissions ❗️
  func search() {
//    public func search(_ name: String, onCompleted: @escaping (GTLRDrive_File?, Error?) -> ()) {
      let query = GTLRDriveQuery_FilesList.query()
//      query.pageSize = 1
//      query.q = "id contains '1UMz_c0P0531pvcuS1PX3OaahxVfUgFTW'"
    query.q = "name contains 'pixelated'"
    query.fields = "files(id,webViewLink,webContentLink,iconLink,exportLinks,thumbnailLink,permissionIds,permissions,linkShareMetadata)"
//    query.q = "'1UMz_c0P0531pvcuS1PX3OaahxVfUgFTW'"
      service.executeQuery(query) { (ticket, results, error) in
        //onCompleted((results as? GTLRDrive_FileList)?.files?.first, error)
        
        if let files = (results as? GTLRDrive_FileList)?.files { // GTLRDrive_File
          for file in files {
            print("\nFILE:")
            dump(file)
            
            if let id = file.identifier, id == "1I8jdNleysnZzcg5-FeZk6yV0gIaB1WKf" {
//              print("! FOUND !")
              print("\t\(file.webViewLink)")
              print("\t\(file.webContentLink)")
              print("\t\(file.iconLink)")
//              print("\t\(file.exportLinks)") // nil
              print("\t\(file.thumbnailLink)")
              print("\t\(file.permissions)")
              print("\t\(file.permissionIds)") // 17306269287647581270
              print("\t\(file.kind)")
              print("\t\(file.linkShareMetadata)")
            }
          }
        }
        /**
         *  Callback block for query execution.
         *
         *  @param callbackTicket The ticket that tracked query execution.
         *  @param object         The result of query execution. This will be derived from
         *                        GTLRObject. The object may be nil for operations such as DELETE which
         *                        do not return an object.  The object will be a GTLRBatchResult for
         *                        batch operations, and GTLRDataObject for media downloads.
         *  @param callbackError  If non-nil, the query execution failed.  For batch requests,
         *                        this may be nil even if individual queries in the batch have failed.
         */
//        typedef void (^GTLRServiceCompletionHandler)(GTLRServiceTicket *callbackTicket,
//                                                     id _Nullable object,
//                                                     NSError * _Nullable callbackError);
        
      }
//    }
  }

  func updatePermission() {
    /**
     *  Fetches a @c GTLRDrive_Permission.
     *
     *  Updates a permission with patch semantics.
     *
     *  @param object The @c GTLRDrive_Permission to include in the query.
     *  @param fileId The ID of the file or shared drive.
     *  @param permissionId The ID of the permission.
     *
     *  @return GTLRDriveQuery_PermissionsUpdate
     */
    //    + (instancetype)queryWithObject:(GTLRDrive_Permission *)object
    //  fileId:(NSString *)fileId
    //  permissionId:(NSString *)permissionId;
    
    // TODO: GTLRDrive_Permission
    /**
     *  The role granted by this permission. While new values may be supported in
     *  the future, the following are currently allowed:
     *  - owner
     *  - organizer
     *  - fileOrganizer
     *  - writer
     *  - commenter
     *  - reader
     */
    /// @property(nonatomic, copy, nullable) NSString *role;
    /**
     *  The type of the grantee. Valid values are:
     *  - user
     *  - group
     *  - domain
     *  - anyone When creating a permission, if type is user or group, you must
     *  provide an emailAddress for the user or group. When type is domain, you must
     *  provide a domain. There isn't extra information required for a anyone type.
     */
    /// @property(nonatomic, copy, nullable) NSString *type;
    
    let fileId = "1I8jdNleysnZzcg5-FeZk6yV0gIaB1WKf"
    // object
    let q = GTLRDriveQuery_PermissionsCreate.query(withObject: .init(json: ["role": "reader", "type": "anyone"]), fileId: fileId)
    service.executeQuery(q) { ticket, result, error in
      guard error == nil else {
        fatalError(error!.localizedDescription)
      }
      
      print("\nPERMISSION CREATE SUCCESS!\nresult:\n")
      dump(result)
    }
//    let q = GTLRDriveQuery_PermissionsUpdate.query(withObject: .init(), fileId: <#T##String#>, permissionId: <#T##String#>)
//    let newPermission = GTLDrivePermission.init()
//    GTLDrivePermission *newPermission = [GTLDrivePermission object];
//    // User or group e-mail address, domain name or nil for @"default" type.
//    newPermission.value = value;
//    // The value @"user", @"group", @"domain" or @"default".
//    newPermission.type = type;
//    // The value @"owner", @"writer" or @"reader".
//    newPermission.role = role;
//
//    GTLQueryDrive *query =
//    [GTLQueryDrive queryForPermissionsInsertWithObject:newPermission
//                                                fileId:fileId];
//    // queryTicket can be used to track the status of the request.
//    GTLServiceTicket *queryTicket =
//    [service executeQuery:query
//        completionHandler:^(GTLServiceTicket *ticket,
//                            GTLDrivePermission *permission, NSError *error) {
//      if (error == nil) {
//        completionBlock(permission, nil);
//      } else {
//        NSLog(@"An error occurred: %@", error);
//        completionBlock(nil, error);
//      }
//    }];
  }

  func uploadFileWithPermissions(
    name: String,
    fileURL: URL,
    mimeType: String
  ) {
      let file = GTLRDrive_File()
      file.name = name
//      file.parents = [folderID]
      
      // Optionally, GTLRUploadParameters can also be created with a Data object.
      let uploadParameters = GTLRUploadParameters(fileURL: fileURL, mimeType: mimeType)
      
      let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
    
//    GTLRDriveQuery_PermissionsCreate
//    GTLRDriveQuery_PermissionsGet
//    GTLRDriveQuery_PermissionsList
      
      service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
        // This block is called multiple times during upload and can
        // be used to update a progress indicator visible to the user.
        print(". Uploading... [\(totalBytesUploaded) bytes / \(totalBytesExpectedToUpload) bytes]")
      }
      
      service.executeQuery(query) { (_, result, error) in
        guard error == nil else {
          fatalError(error!.localizedDescription)
        }
        
        // Successful upload if no error is returned.
        print("\nUPLOAD SUCCESS!\nresult:\n")
        dump(result as? GTLRDrive_File)
        let f = result as! GTLRDrive_File
        print("\t\(f.webViewLink)") //
        print("\t\(f.webContentLink)")
        print("\t\(f.iconLink)")
        print("\t\(f.exportLinks)")
        print("\t\(f.thumbnailLink)")
        print("\t\(f.permissions)")
        print("\t\(f.permissionIds)")
        print("\t\(f.kind)")
        print("\t\(f.linkShareMetadata)")
        print("end")
//      https://drive.google.com/file/d/1mSesyfz0T3Xyfrx78jHjMIXd9FvVE0z2/view
//      https://drive.google.com/file/d/1UMz_c0P0531pvcuS1PX3OaahxVfUgFTW/view
      }
    }
}
