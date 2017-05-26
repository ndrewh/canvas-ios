/**
 * @flow
 *
 * - When single due date assigned to everyone, display due date, assignees (i.e., "Everyone"), and available from/to dates
 * - When single due date assigned to one person, display due date, assignee (e.g., "Tom Smith"), and available from/to dates
 * - When single due date assigned to one section or group, display due date, assignee (e.g., "Student Group 2") and available from/to dates
 * - When single due date assigned to more than one person and less than everyone, display due date, assignees (e.g., "20 people"), and available from/to dates
 * - When multiple due dates, display "Multiple due dates"
 * - Assigned to multiple sections or groups, treat as multiple due dates
 * - Assigned to at least one section or group and at least one person, treat as multiple due dates
 * - if no Available To date, display double dash
 * - if available to date is in the past, display "Availability: Closed" rather than available from/to dates
 * - If multiple due dates, don't show closed unless all availability dates are past
 */

import React, { Component } from 'react'

import {
  View,
  StyleSheet,
} from 'react-native'
import i18n from 'format-message'
import AssignmentDates from '../../../common/AssignmentDates'
import { formattedDueDate } from '../../../common/formatters'
import { Text } from '../../../common/text'

type Props = {
  assignment: Assignment,
}

export default class DueDates extends Component<any, Props, any> {

  renderMultipleDueDates (): React.Element<View> {
    const title = i18n('Multiple Due Dates')

    return <View style={styles.container}>
             <Text>{title}</Text>
           </View>
  }

  renderAvailability (dates: AssignmentDates): React.Element<View> {
    if (dates.availabilityClosed()) {
      const availabilityClosedTitle = i18n('Availability:')

      const availabilityClosedInfo = i18n('Closed')

      return <View>
               <Text style={styles.textContainer}>
                 <Text style={styles.descriptionText}>{availabilityClosedTitle}</Text>
                 <Text style={styles.infoText}>{` ${availabilityClosedInfo}`}</Text>
               </Text>
             </View>
    }

    const availableFromTitle = i18n('Available from:')

    const availableToTitle = i18n('Available to:')

    const availableFrom = dates.bestAvailableFrom()
    const availableTo = dates.bestAvailableTo()
    const availableFromText = availableFrom ? formattedDueDate(availableFrom) : '--'
    const availableToText = availableTo ? formattedDueDate(availableTo) : '--'

    let availableFromAccessibilityLabel
    let availableToAccessibilityLabel

    if (!availableFrom) {
      availableFromAccessibilityLabel = i18n('No available from date set.')
    }

    if (!availableTo) {
      availableToAccessibilityLabel = i18n('No available to date set.')
    }

    return (<View>
              <View accessible={true} accessibilityLabel={availableFromAccessibilityLabel}>
                <Text style={styles.textContainer}>
                  <Text style={styles.descriptionText}>{availableFromTitle}</Text>
                  <Text style={styles.infoText}>{` ${availableFromText}`}</Text>
                </Text>
              </View>
              <View accessible={true} accessibilityLabel={availableToAccessibilityLabel}>
                <Text style={styles.textContainer}>
                  <Text style={styles.descriptionText}>{availableToTitle}</Text>
                  <Text style={styles.infoText}>{` ${availableToText}`}</Text>
                </Text>
              </View>
          </View>)
  }

  renderSingleDueDate (dates: AssignmentDates): ReactElement<View> {
    const dueTitle = i18n('Due:')

    const forTitle = i18n('For:')

    const dueAtValue = dates.bestDueAt() ? formattedDueDate(dates.bestDueAt()) : '--'
    const availability = this.renderAvailability(dates)
    let dueAtAccessibilityLabel

    if (!dates.bestDueAt()) {
      dueAtAccessibilityLabel = i18n('No due date set.')
    }

    return (<View style={styles.container}>
              <View accessible={true} accessibilityLabel={dueAtAccessibilityLabel}>
                <Text style={styles.textContainer}>
                  <Text style={styles.descriptionText}>{dueTitle}</Text>
                  <Text style={styles.infoText}>{` ${dueAtValue}`}</Text>
                </Text>
              </View>
              <Text style={styles.textContainer}>
                <Text style={styles.descriptionText}>{forTitle}</Text>
                <Text style={styles.infoText}>{` ${dates.bestDueDateTitle()}`}</Text>
              </Text>
              {availability}
           </View>)
  }

  render (): React.Element<View> {
    const dates = new AssignmentDates(this.props.assignment)

    if (dates.hasMultipleDueDates()) {
      return this.renderMultipleDueDates()
    }

    return this.renderSingleDueDate(dates)
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  textContainer: {
    paddingTop: 2,
  },
  descriptionText: {
    fontWeight: '600',
  },
  infoText: {
  },
})
