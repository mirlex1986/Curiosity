//
//  Images.swift
//  Curiosity
//
//  Created by Алексей on 25.04.2021.
//

import RealmSwift

class MarsPhoto: Object {
    @objc dynamic var id = Int()
    @objc dynamic var img = Data()
}


class DeletedMarsPhoto: Object {
    @objc dynamic var id = Int()
}
