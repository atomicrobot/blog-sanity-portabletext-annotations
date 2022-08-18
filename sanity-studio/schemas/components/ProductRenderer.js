import React from 'react'
import PropTypes from 'prop-types'

const ProductRenderer = props => {
    return <span>{props.children}</span>
}

ProductRenderer.propTypes = {
    children: PropTypes.node.isRequired,
    _ref: PropTypes.node.isRequired,
}

export default ProductRenderer