export default {
    name: 'productAnnotation',
    type: 'object',
    title: 'Reference to Product',
    fields: [
      {
        title: 'Product',
        name: 'productReference',
        type: 'reference',
        to: [
            {
                type: 'product'
            }
        ],
      },
      {
        title: 'User Prompt',
        name: 'prompt',
        type: 'string'
      },
    ]
  }