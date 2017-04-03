/**
 * @flow
 */

import React, { Component } from 'react'
import { Heading2 } from '../../../common/text'
import color from '../../../common/colors'
import DisclosureIndicator from '../../../common/components/DisclosureIndicator'

import {
  View,
  TouchableHighlight,
  Image,
  StyleSheet,
} from 'react-native'

export default class AssignmentSection extends Component {

  render (): ReactElement<*> {
    let dividerStyle = {}
    let headerStyle = {}
    if (!this.props.isFirstRow) {
      dividerStyle = assignmentSectionStyles.divider
      headerStyle = assignmentSectionStyles.header
    }

    return (
      <TouchableHighlight onPress={this.props.onPress}>
        <View style={[assignmentSectionStyles.container, this.props.style]} >
          <View style={dividerStyle}></View>
          <View style={assignmentSectionStyles.innerContainer}>
            <View style={{ flex: 1 }}>
              <View style={assignmentSectionStyles.titleContainer}>
                {
                  this.props.image && <Image source={this.props.image} style={assignmentSectionStyles.image} />
                }
                <Heading2 style={headerStyle}>{this.props.title}</Heading2>
              </View>
              {this.props.children}
            </View>

            { this.props.showDisclosureIndicator && <View style={assignmentSectionStyles.disclosureIndicatorContainer} >
                                                      <DisclosureIndicator style={{ right: 0 }} />
                                                    </View> }
          </View>
        </View>
      </TouchableHighlight>
    )
  }
}

const PADDING = 16

const assignmentSectionStyles = StyleSheet.create({
  container: {
    flex: 1,
    paddingLeft: PADDING,
    paddingRight: PADDING,
    paddingBottom: PADDING,
    backgroundColor: 'white',
  },
  innerContainer: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
  },
  divider: {
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: color.grey2,
    paddingBottom: PADDING,
  },
  titleContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 4,
  },
  header: {
    color: color.grey4,
    fontSize: 16,
    paddingTop: 2,
  },
  image: {
    tintColor: color.grey4,
    height: 19,
    width: 19,
    marginRight: 5,
  },
  disclosureIndicatorContainer: {
    flex: 0,
    width: 10,
    paddingRight: 2,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-end',
  },
})
