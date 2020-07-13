//
// This file is part of Canvas.
// Copyright (C) 2020-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import Foundation


public class GradeStatisticGraphView: UIView {
    @IBOutlet weak var minPossibleLabel: UILabel!
    @IBOutlet weak var maxPossibleLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var minPossibleBar: UIView!
    @IBOutlet weak var maxPossibleBar: UIView!
    
    @IBOutlet weak var graphArea: UIView!
    
    @IBOutlet weak var minConstraint: NSLayoutConstraint!
    @IBOutlet weak var maxConstraint: NSLayoutConstraint!
    @IBOutlet weak var yourScoreConstraint: NSLayoutConstraint!
    @IBOutlet weak var meanConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var minLabelXConstraint: NSLayoutConstraint!
    @IBOutlet weak var maxLabelXConstraint: NSLayoutConstraint!

    
    @IBOutlet private var lines: [UIView]!
    
    @IBOutlet weak var yourScoreView: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromXib()
        
        yourScoreView.backgroundColor = Brand.shared.primary.ensureContrast(against: .named(.backgroundLightest))
        yourScoreView.layer.cornerRadius = 8.0
        for line in lines {
            line.layer.cornerRadius = 1.0
        }
    }

    public func update(_ assignment: Assignment) {
        setupGraph(assignment: assignment)
    }
    
    func setupGraph(assignment: Assignment) {
        guard let stats = assignment.scoreStatistics, let points_possible = assignment.pointsPossible, let score = assignment.viewableScore, points_possible > 0 else {
            isHidden = true
            return
        }
        isHidden = false
        let usableWidth = graphArea.frame.width - 48.0 - 2.0 // subtract 2 for half width of the outermost bars
                
        let allowedInterval = 0 ... points_possible
        let boundedMin = allowedInterval.clamp(stats.min)
        let boundedMax = allowedInterval.clamp(stats.max)
        let boundedMean = allowedInterval.clamp(stats.mean)
        let boundedScore = allowedInterval.clamp(score)
        
        let possible = CGFloat(points_possible)
        
        let minOffset = usableWidth * (CGFloat(boundedMin) / possible)
        let avgOffset = usableWidth * (CGFloat(boundedMean) / possible)
        let maxOffset = usableWidth * (CGFloat(boundedMax) / possible)
        let studentOffset = usableWidth * (CGFloat(boundedScore) / possible)
        
        minConstraint.constant = minOffset
        meanConstraint.constant = avgOffset
        maxConstraint.constant = maxOffset
        yourScoreConstraint.constant = studentOffset
        
        minLabel.text = "MIN\n\(stats.min)"
        averageLabel.text = "AVG\n\(stats.mean)"
        maxLabel.text = "MAX\n\(stats.max)"
        
        minPossibleLabel.text = NumberFormatter.localizedString(from: NSNumber(value: 0), number: .decimal)
        maxPossibleLabel.text = NumberFormatter.localizedString(from: NSNumber(value: points_possible), number: .decimal)
        
        // Collapse the min (0) and max possible points labels
        // if the actual min/max achieved was within 10% of the
        // bounds.
        //
        // It's not that the layout won't work without collapsing,
        // it's that the min/max/mean would be pushed further from
        // the 'right spot' on the graph if we didn't hide the
        // 0 and max_possible labels (and that information is
        // displayed elsewhere anyway)
        
        if boundedMin / points_possible < 0.1 {
            minPossibleLabel.isHidden = true
            // Make constraint do basically nothing
            minLabelXConstraint.priority = UILayoutPriority.init(rawValue: 1)
        } else {
            minPossibleLabel.isHidden = false
            minLabelXConstraint.priority = UILayoutPriority.required
        }
        
        if boundedMax / points_possible > 0.9 {
            maxPossibleLabel.isHidden = true
            // Make constraint do basically nothing
            maxLabelXConstraint.priority = UILayoutPriority.init(rawValue: 1)
        } else {
            maxPossibleLabel.isHidden = false
            maxLabelXConstraint.priority = UILayoutPriority.required
        }
        
        // We want the layout to update NOW
        layoutIfNeeded()

    }
}

