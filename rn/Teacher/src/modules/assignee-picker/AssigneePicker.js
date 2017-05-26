/**
 * @flow
 */

import React, { Component } from 'react'
import {
  View,
  ScrollView,
  Image,
  TouchableHighlight,
  StyleSheet,
} from 'react-native'

import { connect } from 'react-redux'
import { find } from 'lodash'
import i18n from 'format-message'
import colors from '../../common/colors'
import AssigneeRow from './AssigneeRow'
import Images from '../../images'
import { pickerMapStateToProps, type AssigneePickerProps, type Assignee } from './map-state-to-props'
import Actions from './actions.js'
import EnrollmentActions from '../enrollments/actions'
import UserActions from '../users/actions'
import { Text } from '../../common/text'
import Screen from '../../routing/Screen'

export class AssigneePicker extends Component<any, AssigneePickerProps, any> {

  constructor (props: AssigneePickerProps) {
    super(props)
    this.state = {
      selected: props.assignees || [],
    }
  }

  componentWillReceiveProps = (props: AssigneePickerProps) => {
    const assignees = props.assignees || []
    const selected = this.state.selected.map((item) => {
      const previous = find(assignees, { id: item.id })
      if (previous) {
        Object.assign(item, previous)
      }
      return item
    })

    const newAssignees = assignees.filter((a) => !find(selected, { id: a.id }))

    this.setState({ selected: [...selected, ...newAssignees] })
  }

  componentDidMount () {
    this.props.refreshSections(this.props.courseID)
    const userIds = this.props.assignees.filter(a => a.type === 'student').map(a => a.dataId)
    this.props.refreshUsers(userIds)
  }

  done = () => {
    if (this.props.callback) {
      this.props.callback(this.state.selected || [])
    } else {
      this.props.navigator.dismiss()
    }
  }

  dismiss = () => {
    this.props.navigator.dismiss()
  }

  addAssignee = () => {
    this.props.navigator.show(`/courses/${this.props.courseID}/assignee-search`, { modal: true }, { onSelection: this.handleSelectedAssignee })
  }

  handleSelectedAssignee = (assignee: Assignee) => {
    // If trying to add the same assignee twice, DENY
    const existing = find(this.state.selected, { id: assignee.id })
    if (!existing) {
      const selected = [...this.state.selected, assignee]
      this.setState({
        selected,
      })
    }

    this.props.navigator.dismiss()
  }

  deleteAssignee = (assignee: Assignee) => {
    const selected = this.state.selected.filter((a) => {
      return a.id !== assignee.id
    })

    this.setState({
      selected,
    })
  }

  render (): React.Element<View> {
    return (
      <Screen
        title={i18n('Assignees')}
        rightBarButtons={[
          {
            title: i18n('Done'),
            style: 'done',
            testID: 'assignee-picker.dismiss-btn',
            action: this.done,
          },
        ]}
        leftBarButtons={[
          {
            title: i18n('Cancel'),
            testID: 'assignee-picker.cancel-btn',
            action: this.dismiss,
          },
        ]}>
        <ScrollView style={styles.container}>
          { this.state.selected.length > 0 && <View style={styles.space} /> }
          { this.state.selected.map((assignee: Assignee) => <AssigneeRow assignee={assignee} onDelete={this.deleteAssignee} key={assignee.id}/>) }
          <View style={styles.space} />
          <TouchableHighlight style={styles.button} onPress={this.addAssignee}>
            <View style={styles.buttonContainer}>
              <Image source={Images.add} style={styles.buttonImage} />
              <Text style={styles.buttonText}>Add Assignee</Text>
            </View>
          </TouchableHighlight>
        </ScrollView>
      </Screen>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.grey1,
  },
  space: {
    height: 40,
    backgroundColor: colors.grey1,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: colors.seperatorColor,
  },
  button: {
    height: 54,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: colors.seperatorColor,
  },
  buttonContainer: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'white',
    paddingLeft: global.style.defaultPadding,
    paddingRight: global.style.defaultPadding,
  },
  buttonText: {
    color: colors.primaryButton,
    fontSize: 16,
    fontWeight: '600',
  },
  buttonImage: {
    tintColor: colors.primaryButton,
    marginRight: 8,
    height: 18,
    width: 18,
  },
})

let Connected = connect(pickerMapStateToProps, { ...Actions, ...EnrollmentActions, ...UserActions })(AssigneePicker)
export default (Connected: Component<any, AssigneePickerProps, any>)
