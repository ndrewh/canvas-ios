//
// Copyright (C) 2019-present Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

class LoginStartMDMLoginCell: UITableViewCell {
    @IBOutlet weak var domainLabel: DynamicLabel?
    @IBOutlet weak var nameLabel: DynamicLabel?

    func update(login: MDMLogin) {
        let identifier = "LoginStartMDMLoginCell.\(login.host).\(login.username)"
        self.accessibilityIdentifier = identifier
        domainLabel?.text = login.host
        nameLabel?.text = login.username
    }
}